use base64::{Engine, engine::general_purpose::STANDARD};
use peddler::apis::{
    catalog_items_2022_04_01::models as catalog, finances_2024_06_19::models::BigDecimal,
    listings_items_2021_08_01::models as listings,
};
use serde_json::{Value, json};

fn response_body(fixture: &str) -> Vec<u8> {
    let fixture: Value = serde_json::from_str(fixture).unwrap();
    STANDARD
        .decode(fixture["response"]["body_base64"].as_str().unwrap())
        .unwrap()
}

#[test]
fn catalog_fixture_decodes_typed_fields() {
    let bytes = response_body(include_str!(
        "../../../test/fixtures/native/catalog_get.json"
    ));
    let item: catalog::Item = serde_json::from_slice(&bytes).unwrap();
    assert_eq!(item.asin.to_string(), "188864544X");
    let summaries = item.summaries.unwrap();
    assert_eq!(summaries.len(), 1);
    assert_eq!(summaries[0].marketplace_id, "A1F83G8C2ARO7P");
    assert_eq!(
        summaries[0].item_name.as_deref(),
        Some("Dreams: No. 43 (Visionaire S.)")
    );
}

#[test]
fn listings_fixture_decodes_submission_fields_and_present_empty_issues() {
    let bytes = response_body(include_str!(
        "../../../test/fixtures/native/listings_patch.json"
    ));
    let submission: listings::ListingsItemSubmissionResponse =
        serde_json::from_slice(&bytes).unwrap();
    assert_eq!(submission.sku, "SKU123");
    assert_eq!(submission.status, "ACCEPTED");
    assert_eq!(submission.submission_id, "7afea06c396945a09266774570f3caf4");
    assert!(submission.issues.unwrap().is_empty());
}

#[test]
fn future_submission_status_is_retained() {
    let submission: listings::ListingsItemSubmissionResponse = serde_json::from_value(json!({
        "sku":"SKU123", "status":"FUTURE_STATUS", "submissionId":"future"
    }))
    .unwrap();
    assert_eq!(submission.status, "FUTURE_STATUS");
}

#[test]
fn optional_summaries_distinguish_absence_from_empty_and_raw_json_keeps_null() {
    for raw in [
        json!({"asin":"188864544X"}),
        json!({"asin":"188864544X", "summaries":[]}),
        json!({"asin":"188864544X", "summaries":null}),
    ] {
        let bytes = serde_json::to_vec(&raw).unwrap();
        let item: catalog::Item = serde_json::from_slice(&bytes).unwrap();
        if raw.get("summaries").is_some_and(Value::is_array) {
            assert!(item.summaries.unwrap().is_empty());
        } else {
            assert!(item.summaries.is_none());
        }
        let retained: Value = serde_json::from_slice(&bytes).unwrap();
        assert_eq!(retained, raw);
    }
    for raw in [
        json!({"sku":"SKU123"}),
        json!({"sku":"SKU123", "summaries":[]}),
        json!({"sku":"SKU123", "summaries":null}),
    ] {
        let item: listings::Item = serde_json::from_value(raw.clone()).unwrap();
        if raw.get("summaries").is_some_and(Value::is_array) {
            assert!(item.summaries.unwrap().is_empty());
        } else {
            assert!(item.summaries.is_none());
        }
    }
}

#[test]
fn generated_number_fields_and_named_numbers_preserve_json_precision() {
    for number in [
        "0.123456789012345678901234567890123456789",
        "9007199254740993",
    ] {
        let input = format!("{{\"value\":{number}}}");
        let dimension: catalog::Dimension = serde_json::from_str(&input).unwrap();
        assert_eq!(serde_json::to_string(&dimension).unwrap(), input);
        let decimal: BigDecimal = serde_json::from_str(number).unwrap();
        assert_eq!(serde_json::to_string(&decimal).unwrap(), number);
    }
}
