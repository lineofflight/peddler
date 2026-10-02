//! Node-backed integration tests. Run npm ci --prefix tools/openapi first.
mod support;

use peddler_codegen::{generate, manifest::ALL_APIS};
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
    for api in ALL_APIS {
        let operation = if api.module == "listings_items_2021_08_01" {
            "patchListingsItem"
        } else {
            "getCatalogItem"
        };
        let path = checkout.join("models").join(api.source);
        fs::create_dir_all(path.parent().unwrap()).unwrap();
        fs::write(path, spec(operation).to_string()).unwrap();
    }
    support::write_supplemental(root.path());
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
fn default_cli_generates_all_model_and_selected_wire_files_and_nonmutating_check_detects_wire_drift()
 {
    let root = repository();
    let dest = tempfile::tempdir().unwrap();
    let revision = fs::read_to_string(root.path().join("selling-partner-api-models.sha")).unwrap();
    let rendered = generate(
        &root.path().join("selling-partner-api-models/models"),
        revision.trim(),
    )
    .unwrap();
    assert_eq!(rendered.len(), 414);
    for (path, content) in &rendered {
        if path.extension().is_some_and(|ext| ext == "rs") {
            syn::parse_file(content).unwrap();
        }
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
    let obsolete = dest.path().join("crates/peddler/src/apis/obsolete_wire.rs");
    fs::write(&obsolete, "// Generated by peddler-codegen. Do not edit.\n").unwrap();
    let output = cli(root.path(), dest.path(), true);
    assert!(String::from_utf8_lossy(&output.stderr).contains("obsolete_wire.rs"));
    assert!(obsolete.exists());
    fs::remove_file(&wire).unwrap();
    assert!(!cli(root.path(), dest.path(), true).status.success());
    assert!(!wire.exists());
}
#[test]
fn invalid_second_client_leaves_no_partial_model_or_wire_outputs() {
    let root = repository();
    let checkout = root.path().join("selling-partner-api-models");
    let api = ALL_APIS
        .iter()
        .find(|api| api.module == "listings_items_2021_08_01")
        .unwrap();
    let mut invalid = spec("patchListingsItem");
    invalid["paths"]["/items/{sellerId}/{sku}"]["patch"]["parameters"][1]["collectionFormat"] =
        json!("ssv");
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
    assert!(String::from_utf8_lossy(&output.stderr).contains("unsupported array parameter"));
    assert!(!dest.path().join("crates").exists());
}

#[test]
fn success_model_reference_controls_the_generated_facade_type() {
    let mut changed = spec("getCatalogItem");
    changed["definitions"]["FutureItem"] =
        json!({"type":"object","properties":{"future":{"type":"string"}}});
    changed["paths"]["/items/{asin}"]["get"]["responses"]["200"]["schema"]["$ref"] =
        json!("#/definitions/FutureItem");
    let rendered = peddler_codegen::clients::render(&changed, &ALL_APIS[0]).unwrap();
    assert_eq!(
        rendered.operations[0].successes[0].1.as_deref(),
        Some("super::models::FutureItem")
    );
}
#[test]
fn missing_success_model_is_reported_without_panicking() {
    let mut missing = spec("getCatalogItem");
    missing["paths"]["/items/{asin}"]["get"]["responses"]["200"]["schema"]["$ref"] =
        json!("#/definitions/Missing");
    assert!(peddler_codegen::clients::render(&missing, &ALL_APIS[0]).is_err());
}
