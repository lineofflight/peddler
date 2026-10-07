use std::path::Path;

#[test]
fn amazon_single_schema_items_dialect_becomes_a_typed_list() {
    let temp = tempfile::tempdir().unwrap();
    std::fs::create_dir(temp.path().join("schemas")).unwrap();
    std::fs::write(
        temp.path().join("schemas/list.json"),
        r##"{"type":"array","additionalItems":true,"items":[{"type":"string"}]}"##,
    )
    .unwrap();
    let definitions = peddler_codegen::supplemental::json_definitions(
        temp.path(),
        "schemas/list.json",
        "Report",
        None,
    )
    .unwrap();
    assert_eq!(
        definitions.schemas["Report"]["items"],
        serde_json::json!({"type":"string"})
    );
}

#[test]
fn broken_shipment_schema_reuses_canonical_pinned_tracking_types() {
    let checkout = Path::new(env!("CARGO_MANIFEST_DIR")).join("../../selling-partner-api-models");
    let definitions = peddler_codegen::supplemental::json_definitions(
        &checkout,
        "schemas/notifications/ShipmentTrackingMilestoneChangedNotification.json",
        "Notification",
        None,
    )
    .unwrap();
    assert_eq!(
        definitions.schemas["TrackingDetail"]["properties"]["identifier"]["$ref"],
        "#/definitions/TrackingIdentifier"
    );
    assert!(
        definitions.schemas["Notification"]["properties"]
            .get("notificationMetadata")
            .is_some()
    );
    assert_eq!(
        definitions.schemas["Notification"]["additionalProperties"],
        serde_json::json!({})
    );
}

#[test]
fn every_source_has_a_public_root_and_renders_the_same_twice() {
    let root = Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
    let checkout = root.join("selling-partner-api-models");
    let revision = std::fs::read_to_string(root.join("selling-partner-api-models.sha")).unwrap();
    peddler_codegen::supplemental::verify_sources(&checkout, revision.trim()).unwrap();
    let first = peddler_codegen::generate_supplemental(&checkout, revision.trim()).unwrap();
    assert_eq!(
        first,
        peddler_codegen::generate_supplemental(&checkout, revision.trim()).unwrap()
    );
    for (family, root_type) in [
        ("reports", "Report"),
        ("feeds", "Feed"),
        ("notifications", "Notification"),
        ("data_kiosk", "Response"),
    ] {
        let base = Path::new("crates/peddler/src").join(family);
        let index = syn::parse_file(&first[&base.join("mod.rs")]).unwrap();
        let modules = index.items.iter().filter_map(|item| match item {
            syn::Item::Mod(item) => Some(item),
            _ => None,
        });
        for module in modules {
            let path = base.join(format!("{}.rs", module.ident));
            let content = &first[&path];
            let syntax = syn::parse_file(content).unwrap();
            assert!(
                syntax.items.iter().any(|item| match item {
                    syn::Item::Struct(item) =>
                        item.ident == root_type && matches!(item.vis, syn::Visibility::Public(_)),
                    syn::Item::Enum(item) =>
                        item.ident == root_type && matches!(item.vis, syn::Visibility::Public(_)),
                    syn::Item::Type(item) =>
                        item.ident == root_type && matches!(item.vis, syn::Visibility::Public(_)),
                    _ => false,
                }),
                "missing {root_type} in {}",
                path.display()
            );
        }
    }
}

#[test]
fn unknown_root_refs_and_network_refs_fail_without_schema_fallback() {
    let temp = tempfile::tempdir().unwrap();
    std::fs::create_dir(temp.path().join("schemas")).unwrap();
    for reference in [
        "#/definitions/Missing",
        "https://example.invalid/model.json",
    ] {
        std::fs::write(
            temp.path().join("schemas/unknown.json"),
            serde_json::json!({"$ref":reference,"definitions":{}}).to_string(),
        )
        .unwrap();
        assert!(
            peddler_codegen::supplemental::json_definitions(
                temp.path(),
                "schemas/unknown.json",
                "Notification",
                None
            )
            .is_err()
        );
    }
}
