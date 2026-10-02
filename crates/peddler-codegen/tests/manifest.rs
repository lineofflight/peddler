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
