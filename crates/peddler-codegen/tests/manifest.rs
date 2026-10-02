use peddler_codegen::manifest::ALL_APIS;
use std::collections::BTreeSet;

#[test]
fn manifest_covers_all_versions_and_ruby_latest_aliases() {
    assert_eq!(ALL_APIS.len(), 70);
    assert_eq!(
        ALL_APIS
            .iter()
            .map(|api| api.source)
            .collect::<BTreeSet<_>>()
            .len(),
        70
    );
    assert_eq!(
        ALL_APIS
            .iter()
            .map(|api| api.module)
            .collect::<BTreeSet<_>>()
            .len(),
        70
    );
    assert_eq!(ALL_APIS.iter().filter(|api| api.latest).count(), 58);
    for api in ALL_APIS {
        assert_eq!(api.module, format!("{}_{}", api.family, api.version));
    }
    let shipping = ALL_APIS
        .iter()
        .find(|api| api.module == "shipping_v2")
        .unwrap();
    assert!(shipping.latest);
    assert_eq!(shipping.source, "shipping-api-model/shippingV2.json");
    assert!(
        ALL_APIS
            .iter()
            .any(|api| api.module == "external_fulfillment_shipments_2024_09_11")
    );
    assert!(
        ALL_APIS
            .iter()
            .any(|api| api.module == "finances_invoices_2026_06_25")
    );
}

#[test]
fn committed_operation_inventory_covers_every_pinned_namespace_and_distinct_key() {
    let inventory: serde_json::Value =
        serde_json::from_str(include_str!("../operation-inventory.json")).unwrap();
    assert_eq!(
        inventory["revision"],
        include_str!("../../../selling-partner-api-models.sha").trim()
    );
    let apis = inventory["apis"].as_array().unwrap();
    assert_eq!(apis.len(), 70);
    let mut keys = BTreeSet::new();
    let mut methods = std::collections::BTreeMap::new();
    let mut multi = 0;
    let mut multi_success = 0;
    for (actual, expected) in apis.iter().zip(ALL_APIS) {
        assert_eq!(actual["source"], expected.source);
        assert_eq!(actual["module"], expected.module);
        assert_eq!(actual["latest"], expected.latest);
        for op in actual["operations"].as_array().unwrap() {
            assert!(keys.insert(op["key"].as_str().unwrap()));
            *methods.entry(op["method"].as_str().unwrap()).or_insert(0) += 1;
            multi_success += usize::from(op["successes"].as_array().unwrap().len() > 1);
            for p in op["parameters"].as_array().unwrap() {
                if p["schema"]["type"] == "array" && p["csv"] == false && p["in"] == "query" {
                    multi += 1;
                    assert_eq!(p["wire_name"], "mskus");
                }
            }
        }
    }
    assert_eq!(keys.len(), 384);
    assert_eq!(
        methods,
        std::collections::BTreeMap::from([
            ("GET", 194),
            ("POST", 133),
            ("PUT", 37),
            ("PATCH", 7),
            ("DELETE", 13)
        ])
    );
    assert_eq!(multi, 2);
    assert_eq!(multi_success, 9);
    assert_eq!(apis.iter().filter(|api| api["latest"] == true).count(), 58);
    assert!(keys.contains("shipping_v2.link_carrier_account"));
    assert!(keys.contains("shipping_v2.link_carrier_account_put"));
}
