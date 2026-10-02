mod array;
mod map;
mod selection;
#[test]
fn arrays_preserve_numbers_and_absent_optional_lists() {
    let input: serde_json::Value = serde_json::from_str(r##"[{"amount":9007199254740993.1234567890123456789}]"##).unwrap();
    let parsed: array::Report = serde_json::from_value(input.clone()).unwrap();
    assert_eq!(serde_json::to_value(parsed).unwrap(), input);
    assert!(serde_json::from_str::<array::Report>(r##"[{"amount":"wrong"}]"##).is_err());
}
#[test]
fn maps_and_external_references_are_typed() {
    let input = serde_json::json!({"sku":{"quantity":9007199254740993_i64}});
    let parsed: map::Feed = serde_json::from_value(input.clone()).unwrap();
    assert_eq!(serde_json::to_value(parsed).unwrap(), input);
    assert!(serde_json::from_str::<map::Feed>(r##"{"sku":{"quantity":"wrong"}}"##).is_err());
}
#[test]
fn partial_selection_and_nested_list_nullability_survive() {
    let value: selection::Record = serde_json::from_str("{}").unwrap();
    assert!(value.labels.is_none());
    let input = serde_json::json!({"labels":["a"],"nullableLabels":[null,"b"],"nested":[null,[1,2]],"state":"FUTURE"});
    let value: selection::Record = serde_json::from_value(input.clone()).unwrap();
    assert_eq!(serde_json::to_value(value).unwrap(), input);
    assert!(serde_json::from_str::<selection::Record>(r##"{"labels":[null]}"##).is_err());
    assert!(serde_json::from_str::<selection::Record>(r##"{"nested":[[null]]}"##).is_err());
}
