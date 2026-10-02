use peddler::apis::{
    catalog_items_2022_04_01::models::Dimension, finances_2024_06_19::models::BigDecimal,
};

#[test]
fn generated_number_fields_and_named_numbers_preserve_json_precision() {
    for number in [
        "0.123456789012345678901234567890123456789",
        "9007199254740993",
    ] {
        let input = format!("{{\"value\":{number}}}");
        let dimension: Dimension = serde_json::from_str(&input).unwrap();
        assert_eq!(serde_json::to_string(&dimension).unwrap(), input);
        let decimal: BigDecimal = serde_json::from_str(number).unwrap();
        assert_eq!(serde_json::to_string(&decimal).unwrap(), number);
    }
}
