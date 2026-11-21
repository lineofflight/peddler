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

/// A checkout holding these files, empty.
fn checkout(files: &[&str]) -> tempfile::TempDir {
    let temp = tempfile::tempdir().unwrap();
    for file in files {
        let path = temp.path().join(file);
        std::fs::create_dir_all(path.parent().unwrap()).unwrap();
        std::fs::write(path, "{}").unwrap();
    }
    temp
}

/// The schemas are the files the Ruby generator reads, named as it names them, so a
/// schema Amazon adds needs no edit.
#[test]
fn a_schema_is_found_and_named_as_the_ruby_generator_does() {
    let temp = checkout(&[
        "schemas/reports/accountHealthReport-2020-11-18.json",
        "schemas/reports/endUserDataReport.json",
        "schemas/reports/marketplaceAsinPageViewMetrics.json",
        "schemas/reports/nested/deeperReport.json",
        "schemas/reports/.hiddenReport.json",
        "schemas/feeds/listings-feed-schema-v2.json",
        "schemas/feeds/listings-feed-schema-v2.example.json",
        "schemas/notifications/FBAInventoryAvailabilityChangeNotification.json",
        "schemas/notifications/B2bAnyOfferChangedNotification.json",
        "schemas/notifications/ListingsItemIssuesChangeNotification_2023-12-13.json",
        "schemas/notifications/ListingsItemMfnQuantityChange.json",
        "schemas/data-kiosk/analytics_salesAndTraffic_2024_04_24.graphql",
        "schemas/data-kiosk/analytics_economics_2024_03_15.graphql",
        "schemas/data-kiosk/notes.json",
    ]);
    let sources = peddler_codegen::supplemental::sources(temp.path()).unwrap();
    let names: Vec<_> = sources
        .iter()
        .map(|source| (source.family.as_str(), source.module.as_str()))
        .collect();
    assert_eq!(
        names,
        [
            ("reports", "account_health_report_2020_11_18"),
            ("reports", "end_user_data"),
            ("reports", "marketplace_asin_page_view_metrics"),
            ("feeds", "listings_feed_schema"),
            ("notifications", "b2b_any_offer_changed"),
            ("notifications", "fba_inventory_availability_change"),
            (
                "notifications",
                "listings_item_issues_change_notification_2023_12_13"
            ),
            ("notifications", "listings_item_mfn_quantity_change"),
            ("data_kiosk", "economics20240315"),
            ("data_kiosk", "sales_and_traffic20240424"),
        ]
    );
}

/// What it can't name, it refuses by the file.
#[test]
fn a_schema_name_it_cant_use_is_refused_by_the_file() {
    for (files, refusal) in [
        (
            &["schemas/reports/fooReport.json", "schemas/reports/foo.json"][..],
            "schemas/reports/fooReport.json: schemas/reports/foo.json is named foo too",
        ),
        (
            &["schemas/reports/type.json"][..],
            "schemas/reports/type.json: type can't name a schema",
        ),
        (
            &["schemas/notifications/Order.Change.json"][..],
            "schemas/notifications/Order.Change.json: order.change can't name a schema",
        ),
    ] {
        let temp = checkout(files);
        let error = peddler_codegen::supplemental::sources(temp.path()).unwrap_err();
        assert_eq!(error.0, refusal);
    }
}

/// As ActiveSupport's `underscore` gives them, with the acronyms the Ruby generator
/// configures: `"APIsUsage".underscore` in Ruby, and so on.
#[test]
fn underscore_is_activesupports_with_peddlers_acronyms() {
    for (word, snake) in [
        (
            "FBAInventoryAvailabilityChange",
            "fba_inventory_availability_change",
        ),
        ("B2bAnyOfferChanged", "b2b_any_offer_changed"),
        ("APIsUsage", "apis_usage"),
        ("SKUsReport", "sk_us_report"),
        ("fooAPIBar", "foo_api_bar"),
        ("URLsList", "urls_list"),
        (
            "ListingsItemIssuesChangeNotification_2023_12_13",
            "listings_item_issues_change_notification_2023_12_13",
        ),
        ("SalesAndTraffic20240424", "sales_and_traffic20240424"),
        ("CODOrders", "cod_orders"),
        ("Code", "code"),
        (
            "accountHealthReport_2020_11_18",
            "account_health_report_2020_11_18",
        ),
        ("ListingsFeedSchema", "listings_feed_schema"),
        ("APIURLs", "api_urls"),
        ("foo_API", "foo_api"),
        ("B2BCatalog", "b2b_catalog"),
        ("ASINs", "asi_ns"),
        ("sellerASINReport", "seller_asin_report"),
        ("X1Y", "x1_y"),
        ("API2Thing", "api2_thing"),
    ] {
        assert_eq!(
            peddler_codegen::supplemental::underscore(word),
            snake,
            "{word}"
        );
    }
}

/// Every schema at the pin gets the name the Ruby generator gave its file.
#[test]
fn every_pinned_schema_is_named_as_in_ruby() {
    let root = Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
    let sources =
        peddler_codegen::supplemental::sources(&root.join("selling-partner-api-models")).unwrap();
    for family in ["reports", "feeds", "notifications", "data_kiosk"] {
        let ruby: std::collections::BTreeSet<_> =
            std::fs::read_dir(root.join("lib/peddler").join(family))
                .unwrap()
                .filter_map(|entry| {
                    let name = entry.unwrap().file_name().into_string().unwrap();
                    name.strip_suffix(".rb").map(str::to_owned)
                })
                .collect();
        let rust: std::collections::BTreeSet<_> = sources
            .iter()
            .filter(|source| source.family == family)
            .map(|source| source.module.clone())
            .collect();
        assert_eq!(rust, ruby, "{family}");
    }
}
