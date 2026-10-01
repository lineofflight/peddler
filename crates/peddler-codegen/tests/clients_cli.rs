//! Node-backed integration tests. Run npm ci --prefix tools/openapi first.
use peddler_codegen::{generate, manifest::APIS};
use serde_json::{Value, json};
use std::{fs, path::Path, process::Command};

fn spec(operation: &str) -> Value {
    let catalog = operation == "getCatalogItem";
    let mut parameters = vec![
        json!({"in":"path","name":if catalog {"asin"} else {"sellerId"},"type":"string","required":true}),
        json!({"in":"query","name":"marketplaceIds","type":"array","items":{"type":"string"},"collectionFormat":"csv","required":true}),
        json!({"in":"query","name":"includedData","type":"array","items":{"type":"string"},"collectionFormat":"csv","default":[if catalog {"summaries"} else {"issues"}]}),
    ];
    if !catalog {
        parameters.push(json!({"in":"path","name":"sku","type":"string","required":true}));
        parameters.push(json!({"in":"body","name":"body","required":true,"schema":{"$ref":"#/definitions/ListingsItemPatchRequest"}}));
    }
    json!({"swagger":"2.0","info":{"title":"Synthetic","version":"1"},"produces":["application/json"],"consumes":["application/json"],"paths":{if catalog {"/items/{asin}"} else {"/items/{sellerId}/{sku}"}:{if catalog {"get"} else {"patch"}:{"operationId":operation,"parameters":parameters,"responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/Item"}},"404":{"description":"missing","schema":{"$ref":"#/definitions/Item"}}}}}},"definitions":{"Item":{"type":"object","required":["sku"],"properties":{"sku":{"type":"string"}}},"ListingsItemPatchRequest":{"type":"object","required":["patches"],"properties":{"patches":{"type":"array","items":{"type":"string"}}}}}})
}
fn git(root: &Path, args: &[&str]) -> String {
    let output = Command::new("git")
        .arg("-C")
        .arg(root)
        .args(args)
        .env("GIT_AUTHOR_NAME", "Codegen test")
        .env("GIT_AUTHOR_EMAIL", "test@example.invalid")
        .env("GIT_COMMITTER_NAME", "Codegen test")
        .env("GIT_COMMITTER_EMAIL", "test@example.invalid")
        .output()
        .unwrap();
    assert!(
        output.status.success(),
        "{}",
        String::from_utf8_lossy(&output.stderr)
    );
    String::from_utf8(output.stdout).unwrap().trim().to_owned()
}
fn repository() -> tempfile::TempDir {
    let root = tempfile::tempdir().unwrap();
    let checkout = root.path().join("selling-partner-api-models");
    for api in APIS {
        let path = checkout.join("models").join(api.source);
        fs::create_dir_all(path.parent().unwrap()).unwrap();
        fs::write(path, spec(api.operation).to_string()).unwrap();
    }
    git(&checkout, &["init", "--quiet"]);
    git(&checkout, &["add", "."]);
    git(
        &checkout,
        &[
            "-c",
            "commit.gpgsign=false",
            "commit",
            "--quiet",
            "-m",
            "specs",
        ],
    );
    fs::write(
        root.path().join("selling-partner-api-models.sha"),
        git(&checkout, &["rev-parse", "HEAD"]) + "\n",
    )
    .unwrap();
    root
}
fn cli(root: &Path, dest: &Path, check: bool) -> std::process::Output {
    let mut command = Command::new(env!("CARGO_BIN_EXE_peddler-codegen"));
    command
        .arg("--root")
        .arg(root)
        .arg("--output-root")
        .arg(dest);
    if check {
        command.arg("--check");
    }
    command.output().unwrap()
}
#[test]
fn default_cli_generates_all_nine_files_and_nonmutating_check_detects_wire_drift() {
    let root = repository();
    let dest = tempfile::tempdir().unwrap();
    let revision = fs::read_to_string(root.path().join("selling-partner-api-models.sha")).unwrap();
    let rendered = generate(
        &root.path().join("selling-partner-api-models/models"),
        revision.trim(),
    )
    .unwrap();
    assert_eq!(rendered.len(), 9);
    for content in rendered.values() {
        syn::parse_file(content).unwrap();
    }
    for _ in 0..2 {
        let output = cli(root.path(), dest.path(), false);
        assert!(
            output.status.success(),
            "{}",
            String::from_utf8_lossy(&output.stderr)
        );
        for (path, content) in &rendered {
            assert_eq!(
                fs::read_to_string(dest.path().join(path)).unwrap(),
                *content
            );
        }
    }
    let before: Vec<_> = rendered
        .keys()
        .map(|path| {
            fs::metadata(dest.path().join(path))
                .unwrap()
                .modified()
                .unwrap()
        })
        .collect();
    assert!(cli(root.path(), dest.path(), true).status.success());
    let after: Vec<_> = rendered
        .keys()
        .map(|path| {
            fs::metadata(dest.path().join(path))
                .unwrap()
                .modified()
                .unwrap()
        })
        .collect();
    assert_eq!(before, after);
    let wire = dest
        .path()
        .join("crates/peddler/src/apis/catalog_items_2022_04_01/wire.rs");
    fs::write(&wire, "// drift\n").unwrap();
    let before = fs::metadata(&wire).unwrap().modified().unwrap();
    let output = cli(root.path(), dest.path(), true);
    assert!(!output.status.success());
    assert!(String::from_utf8_lossy(&output.stderr).contains("wire.rs"));
    assert_eq!(fs::read_to_string(&wire).unwrap(), "// drift\n");
    assert_eq!(fs::metadata(&wire).unwrap().modified().unwrap(), before);
    fs::remove_file(&wire).unwrap();
    assert!(!cli(root.path(), dest.path(), true).status.success());
    assert!(!wire.exists());
}
#[test]
fn invalid_second_client_leaves_no_partial_model_or_wire_outputs() {
    let root = repository();
    let checkout = root.path().join("selling-partner-api-models");
    let api = &APIS[1];
    let mut invalid = spec(api.operation);
    invalid["paths"]["/items/{sellerId}/{sku}"]["patch"]["parameters"][1]["collectionFormat"] =
        json!("multi");
    fs::write(
        checkout.join("models").join(api.source),
        invalid.to_string(),
    )
    .unwrap();
    git(&checkout, &["add", "."]);
    git(
        &checkout,
        &[
            "-c",
            "commit.gpgsign=false",
            "commit",
            "--quiet",
            "-m",
            "invalid",
        ],
    );
    fs::write(
        root.path().join("selling-partner-api-models.sha"),
        git(&checkout, &["rev-parse", "HEAD"]) + "\n",
    )
    .unwrap();
    let dest = tempfile::tempdir().unwrap();
    let output = cli(root.path(), dest.path(), false);
    assert!(!output.status.success());
    assert!(String::from_utf8_lossy(&output.stderr).contains("unsupported selected parameter"));
    assert!(!dest.path().join("crates").exists());
}

#[test]
fn success_model_reference_controls_the_generated_facade_response_alias() {
    let root = repository();
    let api = &APIS[0];
    let mut changed = spec(api.operation);
    changed["definitions"]["FutureItem"] =
        json!({"type":"object","properties":{"future":{"type":"string"}}});
    changed["paths"]["/items/{asin}"]["get"]["responses"]["200"]["schema"]["$ref"] =
        json!("#/definitions/FutureItem");
    let models = root.path().join("selling-partner-api-models/models");
    fs::write(models.join(api.source), changed.to_string()).unwrap();
    let rendered = generate(&models, "test-revision").unwrap();
    let metadata =
        &rendered[Path::new("crates/peddler/src/apis/catalog_items_2022_04_01/metadata.rs")];
    let file = syn::parse_file(metadata).unwrap();
    let alias = file
        .items
        .iter()
        .find_map(|item| match item {
            syn::Item::Type(alias) if alias.ident == "ResponseModel" => Some(alias),
            _ => None,
        })
        .expect("facade response alias must come from the selected response reference");
    let syn::Type::Path(path) = alias.ty.as_ref() else {
        panic!("expected model path")
    };
    assert_eq!(path.path.segments.last().unwrap().ident, "FutureItem");
}

#[test]
fn unsupported_request_bodies_and_missing_success_models_fail_generation() {
    let mut catalog = spec("getCatalogItem");
    catalog["paths"]["/items/{asin}"]["get"]["parameters"].as_array_mut().unwrap().push(json!({"in":"body","name":"body","required":true,"schema":{"$ref":"#/definitions/Item"}}));
    assert!(peddler_codegen::clients::render(&catalog, &APIS[0]).is_err());
    let mut listings = spec("patchListingsItem");
    listings["paths"]["/items/{sellerId}/{sku}"]["patch"]["parameters"][4]["schema"]["$ref"] =
        json!("#/definitions/Item");
    assert!(peddler_codegen::clients::render(&listings, &APIS[1]).is_err());
    let mut missing = spec("getCatalogItem");
    missing["paths"]["/items/{asin}"]["get"]["responses"]["200"]["schema"]["$ref"] =
        json!("#/definitions/Missing");
    assert!(peddler_codegen::clients::render(&missing, &APIS[0]).is_err());
}

#[test]
fn formatted_parameters_leave_no_partial_generated_outputs() {
    for array_item in [false, true] {
        let root = repository();
        let checkout = root.path().join("selling-partner-api-models");
        let mut changed = spec("getCatalogItem");
        let parameters = &mut changed["paths"]["/items/{asin}"]["get"]["parameters"];
        if array_item {
            parameters[1]["items"]["format"] = json!("date-time");
        } else {
            parameters[0]["format"] = json!("date-time");
        }
        fs::write(
            checkout.join("models").join(APIS[0].source),
            changed.to_string(),
        )
        .unwrap();
        git(&checkout, &["add", "."]);
        git(
            &checkout,
            &[
                "-c",
                "commit.gpgsign=false",
                "commit",
                "--quiet",
                "-m",
                "formatted",
            ],
        );
        fs::write(
            root.path().join("selling-partner-api-models.sha"),
            git(&checkout, &["rev-parse", "HEAD"]) + "\n",
        )
        .unwrap();
        let destination = tempfile::tempdir().unwrap();
        let output = cli(root.path(), destination.path(), false);
        assert!(
            !output.status.success(),
            "unsupported formatted parameter generated successfully"
        );
        assert!(
            String::from_utf8_lossy(&output.stderr)
                .contains("unsupported selected parameter format")
        );
        assert!(!destination.path().join("crates").exists());
    }
}
