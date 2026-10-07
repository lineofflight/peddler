//! The generator CLI against a synthetic checkout.
mod support;

use peddler_codegen::{generate, manifest::ALL_APIS};
use serde_json::{Value, json};
use std::{fs, path::Path, process::Command};

fn spec(operation: &str) -> Value {
    let catalog = operation == "getCatalogItem";
    let mut parameters = vec![
        json!({"in":"path","name":if catalog {"asin"} else {"sellerId"},"type":"string","required":true}),
        json!({"in":"query","name":"marketplaceIds","type":"array","items":{"type":"string"},"collectionFormat":"csv","required":true}),
        json!({"in":"query","name":"includedData","type":"array","items":{"type":"string"},"collectionFormat":"csv","default":[if catalog {"#{exit}"} else {"issues"}]}),
    ];
    if !catalog {
        parameters.push(json!({"in":"body","name":"patchRequest","required":true,"schema":{"$ref":"#/definitions/ListingsItemPatchRequest"}}));
        parameters.push(json!({"in":"path","name":"sku","type":"string","required":true,"description":"The  seller's\nidentifier for the listing, which is a <a href='https://example.com/sku'>SKU</a>. It is __unique__ to the seller."}));
    }
    let description = if catalog {
        "Returns an item."
    } else {
        "Updates part of a listing. Refer to the [Listings Items guide](doc:listings-items-api-v2021-08-01-use-case-guide).\n**Note:** Only the fields that you send change.\n\n**Usage Plan:**\n\n| Rate | Burst |\n| 5 | 10 |"
    };
    let mut spec = json!({"swagger":"2.0","info":{"title":"Synthetic API.","version":"1","description":"Reads and updates listings. See the <a href=\"https://example.com/guide\">guide</a>."},"produces":["application/json"],"consumes":["application/json"],"paths":{if catalog {"/items/{asin}"} else {"/items/{sellerId}/{sku}"}:{if catalog {"get"} else {"patch"}:{"operationId":operation,"parameters":parameters,"responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/Item"}},"404":{"description":"missing","schema":{"$ref":"#/definitions/Item"}}}}}},"definitions":{"Item":{"type":"object","required":["sku"],"properties":{"sku":{"type":"string"}}},"ListingsItemPatchRequest":{"type":"object","required":["patches"],"properties":{"patches":{"type":"array","items":{"type":"string"}}}}}});
    for (_, methods) in spec["paths"].as_object_mut().unwrap() {
        for (_, operation) in methods.as_object_mut().unwrap() {
            operation["description"] = json!(description);
            operation["responses"]["200"]["x-amzn-api-sandbox"] = json!({"static": [{}]});
        }
    }
    spec
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
    commit(root.path());
    root
}
/// Commits the checkout as it is and pins that revision.
fn commit(root: &Path) {
    let checkout = root.join("selling-partner-api-models");
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
        root.join("selling-partner-api-models.sha"),
        git(&checkout, &["rev-parse", "HEAD"]) + "\n",
    )
    .unwrap();
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
fn default_cli_generates_every_file_and_nonmutating_check_detects_drift() {
    let root = repository();
    let dest = tempfile::tempdir().unwrap();
    let revision = fs::read_to_string(root.path().join("selling-partner-api-models.sha")).unwrap();
    let rendered = generate(
        &root.path().join("selling-partner-api-models/models"),
        revision.trim(),
    )
    .unwrap();
    // v5's signature: required arguments positional in the spec's order, the body under
    // the spec's name, optional ones as keywords. Each goes through its coercion, and a
    // path argument through the check of a segment, the one that ends the path as such.
    // Above it, v5's comment: the description up to its usage plan, links as YARD's, a
    // note in a paragraph of its own, and lines of at most 120 columns.
    let ruby = &rendered[Path::new("lib/peddler/native/apis.rb")];
    assert!(ruby.contains(concat!(
        "      # Updates part of a listing. Refer to the\n",
        "      # {https://developer-docs.amazon.com/sp-api/docs/listings-items-api-v2021-08-01-use-case-guide Listings Items\n",
        "      # guide}.\n",
        "      #\n",
        "      # **Note:** Only the fields that you send change.\n",
        "      #\n",
        "      # @note This operation can make a static sandbox call.\n",
        "      # @param seller_id [String]\n",
        "      # @param marketplace_ids [Array<String>]\n",
        "      # @param included_data [Array<String>]\n",
        "      # @param patch_request [Hash, Array, String]\n",
        "      # @param sku [String] The seller's identifier for the listing, which is a {https://example.com/sku SKU}. It is\n",
        "      #   **unique** to the seller.\n",
        "      # @return [Peddler::Response] The API response\n",
        "      def patch_listings_item(seller_id, marketplace_ids, patch_request, sku, included_data: [\"issues\"])\n",
        "        arguments = {\n",
        "          seller_id: Arguments.segment(\"seller_id\", seller_id),\n",
        "          marketplace_ids: Arguments.array(\"marketplace_ids\", marketplace_ids, required: true),\n",
        "          included_data: Arguments.array(\"included_data\", included_data),\n",
        "          sku: Arguments.segment(\"sku\", sku, last: true),\n",
        "          body: Arguments.body(\"patch_request\", patch_request, required: true),\n",
        "        }\n",
    )));
    // Its class has v5's comment, and the accessor of `Client` names the API and links it.
    assert!(ruby.contains(concat!(
        "    # Synthetic API.\n",
        "    #\n",
        "    # Reads and updates listings. See the {https://example.com/guide guide}.\n",
        "    #\n",
        "    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/listings-items-api-model/listingsItems_2021-08-01.json\n",
        "    class ListingsItems20210801\n",
    )));
    assert!(ruby.contains(concat!(
        "    # @return [Peddler::Native::ListingsItems20210801] Synthetic API, version 1\n",
        "    def listings_items_2021_08_01\n",
    )));
    // A default is text, never code: Ruby would interpolate "#{exit}".
    assert!(ruby.contains(
        "      def get_catalog_item(asin, marketplace_ids, included_data: [\"\\#{exit}\"])\n"
    ));
    let rbs = &rendered[Path::new("sig/peddler/native/apis.rbs")];
    assert!(rbs.contains(
        "def patch_listings_item: (String seller_id, Array[String] marketplace_ids, untyped patch_request, String sku, ?included_data: Array[String]?) -> Response"
    ));
    for (path, content) in &rendered {
        if path.extension().is_some_and(|ext| ext == "rs") {
            // No source carries the revision, so a pin move changes only what the specs changed.
            assert!(!content.contains(revision.trim()), "{}", path.display());
            syn::parse_file(content).unwrap();
        }
    }
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
    let modified = || -> Vec<_> {
        let times = rendered
            .keys()
            .map(|path| fs::metadata(dest.path().join(path)));
        times
            .map(|file| file.unwrap().modified().unwrap())
            .collect()
    };
    let before = modified();
    assert!(cli(root.path(), dest.path(), true).status.success());
    assert_eq!(before, modified());

    let apis = dest.path().join("crates/peddler/src/apis");
    let drifted = apis.join("catalog_items_2022_04_01/facade.rs");
    let missing = apis.join("catalog_items_2022_04_01/models.rs");
    let obsolete = apis.join("obsolete.rs");
    fs::write(&drifted, "// drift\n").unwrap();
    fs::remove_file(&missing).unwrap();
    fs::write(&obsolete, "// Generated by peddler-codegen. Do not edit.\n").unwrap();
    let output = cli(root.path(), dest.path(), true);
    assert!(!output.status.success());
    let stderr = String::from_utf8_lossy(&output.stderr);
    for path in [&drifted, &missing, &obsolete] {
        let path = path
            .strip_prefix(dest.path())
            .unwrap()
            .display()
            .to_string();
        assert!(stderr.contains(&path), "{path} is not in {stderr}");
    }
    assert_eq!(fs::read_to_string(&drifted).unwrap(), "// drift\n");
    assert!(!missing.exists());
    assert!(obsolete.exists());
}
#[test]
fn invalid_second_client_leaves_no_partial_outputs() {
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
    commit(root.path());
    let dest = tempfile::tempdir().unwrap();
    let output = cli(root.path(), dest.path(), false);
    assert!(!output.status.success());
    // The refusal says where: the spec file, then the operation.
    let refusal = format!(
        "{}: patchListingsItem: unsupported array parameter",
        api.source
    );
    let stderr = String::from_utf8_lossy(&output.stderr);
    assert!(stderr.contains(&refusal), "{stderr}");
    assert!(!dest.path().join("crates").exists());
}

/// A run that must fail before it writes anything. Returns what it printed.
fn refused(root: &Path) -> String {
    let dest = tempfile::tempdir().unwrap();
    let output = cli(root, dest.path(), false);
    assert!(!output.status.success());
    assert!(!dest.path().join("crates").exists());
    String::from_utf8_lossy(&output.stderr).into_owned()
}

#[test]
fn mismatched_revision_is_rejected_before_writing() {
    let root = repository();
    fs::write(
        root.path().join("selling-partner-api-models.sha"),
        "0000000000000000000000000000000000000000\n",
    )
    .unwrap();
    assert!(refused(root.path()).contains("revision"));
}

#[test]
fn modified_and_untracked_sources_are_rejected() {
    let root = repository();
    let checkout = root.path().join("selling-partner-api-models");
    let source = format!("models/{}", ALL_APIS[0].source);
    fs::write(checkout.join(&source), "{}\n").unwrap();
    assert!(refused(root.path()).contains("modified"));
    git(&checkout, &["checkout", "--", "models"]);
    git(&checkout, &["rm", "--cached", &source]);
    refused(root.path());
}

#[test]
fn pinned_inventory_rejects_missing_and_extra_api_specs() {
    for extra in [false, true] {
        let root = repository();
        let checkout = root.path().join("selling-partner-api-models");
        if extra {
            fs::write(checkout.join("models/unlisted.json"), "{}").unwrap();
        } else {
            let last = format!("models/{}", ALL_APIS.last().unwrap().source);
            git(&checkout, &["rm", "--quiet", &last]);
        }
        commit(root.path());
        assert!(refused(root.path()).contains("pinned API inventory mismatch"));
    }
}

#[test]
fn supplemental_sources_and_patch_inputs_are_verified_before_export() {
    for (changed, error) in [
        (
            "lib/generator/patches/any_offer_changed.json",
            "notification patch modified",
        ),
        (
            "selling-partner-api-models/schemas/feeds/listings-feed-schema-v2.json",
            "supplemental sources are modified",
        ),
    ] {
        let root = repository();
        fs::write(root.path().join(changed), "{}\n").unwrap();
        let printed = refused(root.path());
        assert!(printed.contains(error), "{printed}");
    }
}

#[test]
fn success_model_reference_controls_the_generated_facade_type() {
    let mut changed = spec("getCatalogItem");
    changed["definitions"]["FutureItem"] =
        json!({"type":"object","properties":{"future":{"type":"string"}}});
    changed["paths"]["/items/{asin}"]["get"]["responses"]["200"]["schema"]["$ref"] =
        json!("#/definitions/FutureItem");
    let operations = peddler_codegen::clients::render(&changed, &ALL_APIS[0]).unwrap();
    assert_eq!(
        operations[0].successes[0].1.as_deref(),
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
