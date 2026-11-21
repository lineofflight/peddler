//! Every API model is named by the Ruby generator's rules, so a model Amazon adds needs
//! no edit.
use peddler_codegen::manifest::{ModelSpec, derive, latest, ruby_class, sources};
use serde_json::{Value, json};
use std::{collections::BTreeSet, path::Path};

/// Models by their path and `info.version`.
fn models(files: &[(&str, &str)]) -> Vec<(String, Value)> {
    files
        .iter()
        .map(|(source, version)| ((*source).to_owned(), json!({"info": {"version": version}})))
        .collect()
}
fn named(files: &[(&str, &str)]) -> Vec<ModelSpec> {
    derive(&models(files)).unwrap()
}
fn refusal(files: &[(&str, &str)]) -> String {
    derive(&models(files)).unwrap_err().0
}

/// An API is named after its directory, without `-api-model` or `-model`, and its version
/// is the spec's. Its Ruby class takes Peddler's acronyms.
#[test]
fn an_api_is_named_after_its_directory() {
    let apis = named(&[
        (
            "amazon-warehousing-and-distribution-model/awd_2024-05-09.json",
            "2024-05-09",
        ),
        ("fba-inventory-api-model/fbaInventory.json", "v1"),
        (
            "delivery-by-amazon/deliveryShipmentInvoiceV2022-07-01.json",
            "2022-07-01",
        ),
    ]);
    let names: Vec<_> = apis
        .iter()
        .map(|api| {
            (
                api.family.as_str(),
                api.module.as_str(),
                ruby_class(&api.module),
            )
        })
        .collect();
    assert_eq!(
        names,
        [
            (
                "amazon_warehousing_and_distribution",
                "amazon_warehousing_and_distribution_2024_05_09",
                "AmazonWarehousingAndDistribution20240509".to_owned()
            ),
            (
                "fba_inventory",
                "fba_inventory_v1",
                "FBAInventoryV1".to_owned()
            ),
            (
                "delivery_by_amazon",
                "delivery_by_amazon_2022_07_01",
                "DeliveryByAmazon20220701".to_owned()
            ),
        ]
    );
}

/// In a directory of several APIs, each is named after its file, without its version.
#[test]
fn an_api_in_a_directory_of_several_is_named_after_its_file() {
    let apis = named(&[
        (
            "external-fulfillment/externalFulfillmentInventory_2024-09-11.json",
            "2024-09-11",
        ),
        (
            "external-fulfillment/externalFulfillmentLocation_2026-07-30.json",
            "2026-07-30",
        ),
        (
            "finances-api-model/financesInvoices_2026-06-25.json",
            "2026-06-25",
        ),
        ("finances-api-model/financesV0.json", "v0"),
        ("finances-api-model/finances_2024-06-19.json", "2024-06-19"),
        ("finances-api-model/transfers_2024-06-01.json", "2024-06-01"),
    ]);
    let modules: Vec<_> = apis.iter().map(|api| api.module.as_str()).collect();
    assert_eq!(
        modules,
        [
            "external_fulfillment_inventory_2024_09_11",
            "external_fulfillment_location_2026_07_30",
            "finances_invoices_2026_06_25",
            "finances_v0",
            "finances_2024_06_19",
            "transfers_2024_06_01",
        ]
    );
}

/// As Peddler 5 picked the version `client.<family>` returns: a dated version is later
/// than any `v` one. Messaging 2026-04-20 is the latest of `messaging`.
#[test]
fn the_latest_version_of_a_family_is_the_last_dated_one() {
    let apis = named(&[
        ("catalog-items-api-model/catalogItemsV0.json", "v0"),
        (
            "catalog-items-api-model/catalogItems_2020-12-01.json",
            "2020-12-01",
        ),
        (
            "catalog-items-api-model/catalogItems_2022-04-01.json",
            "2022-04-01",
        ),
        ("messaging-api-model/messaging.json", "v1"),
        (
            "messaging-api-model/messaging_2026-04-20.json",
            "2026-04-20",
        ),
        ("sellers-api-model/sellers.json", "v1"),
        ("shipping-api-model/shipping.json", "v1"),
        ("shipping-api-model/shippingV2.json", "v2"),
    ]);
    let latest_modules: Vec<_> = apis
        .iter()
        .filter(|api| api.latest)
        .map(|api| api.module.as_str())
        .collect();
    assert_eq!(
        latest_modules,
        [
            "catalog_items_2022_04_01",
            "messaging_2026_04_20",
            "sellers_v1",
            "shipping_v2",
        ]
    );
    let versions = |list: &[&str]| list.iter().map(|v| (*v).to_owned()).collect::<Vec<_>>();
    assert_eq!(
        latest(&versions(&["2024_01_01", "v9", "v10"])),
        Some("2024_01_01")
    );
    // Strings, as Ruby compares them.
    assert_eq!(latest(&versions(&["v9", "v10"])), Some("v9"));
    assert_eq!(latest(&[]), None);
}

/// What it can't name, it refuses by the file.
#[test]
fn a_name_it_cant_derive_is_refused_by_the_file() {
    // APIs of different names in a directory that isn't listed as named after its files
    let error = refusal(&[
        ("orders-api-model/ordersV0.json", "v0"),
        ("orders-api-model/returns_2026-01-01.json", "2026-01-01"),
    ]);
    assert!(
        error.starts_with(
            "orders-api-model/ordersV0.json, orders-api-model/returns_2026-01-01.json: "
        ) && error.contains("FILENAME_BASED_DIRECTORIES"),
        "{error}"
    );
    // A version that can't be part of a name
    let error = refusal(&[("sales-api-model/sales.json", "1.0")]);
    assert!(error.starts_with("sales-api-model/sales.json: "), "{error}");
    // Two models of one name
    let error = refusal(&[
        ("sales-api-model/sales.json", "v1"),
        ("sales-api-model/salesV1.json", "v1"),
    ]);
    assert!(
        error.starts_with(
            "sales-api-model/salesV1.json: sales-api-model/sales.json is named sales_v1 too"
        ),
        "{error}"
    );
    // A family Ruby can't call
    let error = refusal(&[("end-api-model/end.json", "v1")]);
    assert!(error.starts_with("end-api-model/end.json: "), "{error}");
    let error = refusal(&[("Sales-api-model/sales.json", "v1")]);
    assert!(error.starts_with("Sales-api-model/sales.json: "), "{error}");
}

/// The models it reads are the JSON files under `models/`, at any depth, none hidden, as
/// `Dir.glob("models/**/*.json")` finds them.
#[test]
fn every_json_file_under_models_is_a_model() {
    let temp = tempfile::tempdir().unwrap();
    for file in [
        "orders-api-model/ordersV0.json",
        "orders-api-model/README.md",
        "deep/er/model.json",
        ".hidden/model.json",
        "orders-api-model/.draft.json",
    ] {
        let path = temp.path().join(file);
        std::fs::create_dir_all(path.parent().unwrap()).unwrap();
        std::fs::write(path, "{}").unwrap();
    }
    assert_eq!(
        sources(temp.path()).unwrap(),
        ["deep/er/model.json", "orders-api-model/ordersV0.json"]
    );
    assert!(sources(&temp.path().join("missing")).unwrap().is_empty());
}

/// Every model at the pin gets the name the Ruby generator gave its file, and each family
/// one latest version.
#[test]
fn every_pinned_model_is_named_as_in_ruby() {
    let root = Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
    let models = root.join("selling-partner-api-models/models");
    let parsed: Vec<_> = sources(&models)
        .unwrap()
        .into_iter()
        .map(|source| {
            let spec =
                serde_json::from_slice(&std::fs::read(models.join(&source)).unwrap()).unwrap();
            (source, spec)
        })
        .collect();
    let apis = derive(&parsed).unwrap();
    let ruby: BTreeSet<_> = std::fs::read_dir(root.join("lib/peddler/apis"))
        .unwrap()
        .filter_map(|entry| {
            let name = entry.unwrap().file_name().into_string().unwrap();
            name.strip_suffix(".rb").map(str::to_owned)
        })
        .collect();
    let rust: BTreeSet<_> = apis.iter().map(|api| api.module.clone()).collect();
    assert_eq!(rust, ruby);
    for api in &apis {
        assert_eq!(api.module, format!("{}_{}", api.family, api.version));
        let latest = apis
            .iter()
            .filter(|other| other.family == api.family && other.latest)
            .count();
        assert_eq!(latest, 1, "{}", api.family);
    }
}

/// As `Peddler::Acronyms.apply` names them in Ruby.
#[test]
fn a_class_is_named_with_peddlers_acronyms() {
    for (module, class) in [
        ("fba_inventory_v1", "FBAInventoryV1"),
        ("orders_v0", "OrdersV0"),
        ("apis_v1", "APIsV1"),
        ("api_urls", "APIURLs"),
        ("b2b_sku_v1", "B2BSKUV1"),
        ("sku_2024_01_01", "Sku20240101"),
        ("code_v1", "CodeV1"),
        ("cod_v1", "CODV1"),
    ] {
        assert_eq!(ruby_class(module), class);
    }
}
