use peddler::{data_kiosk, feeds, notifications};
use serde_json::{Value, json};

#[test]
fn shipment_example_retains_typed_payload_and_extension_fields() {
    let mut input: Value = serde_json::from_str(include_str!(
        "fixtures/supplemental/ShipmentTrackingMilestoneChangedNotification.json"
    ))
    .unwrap();
    input["futureEnvelopeField"] = json!({"id":123});
    input["payload"]["shipmentTrackingMilestoneChangedNotification"]["trackingDetail"]["futureField"] =
        json!("retained");
    let notification: notifications::shipment_tracking_milestone_changed::Notification =
        serde_json::from_value(input.clone()).unwrap();
    assert_eq!(
        notification
            .payload
            .as_ref()
            .unwrap()
            .shipment_tracking_milestone_changed_notification
            .as_ref()
            .unwrap()
            .tracking_detail
            .as_ref()
            .unwrap()
            .identifier
            .aftn
            .as_deref(),
        Some("AFTN987654321")
    );
    assert_eq!(serde_json::to_value(notification).unwrap(), input);
}

#[test]
fn partial_data_kiosk_selection_keeps_precision_and_omitted_fields() {
    let value: data_kiosk::sales_and_traffic20240424::Amount =
        serde_json::from_str(r#"{"amount":9007199254740993.1234567890123456789}"#).unwrap();
    assert!(value.currency_code.is_none());
    assert_eq!(
        value.amount.as_ref().unwrap().to_string(),
        "9007199254740993.1234567890123456789"
    );
    let response: data_kiosk::sales_and_traffic20240424::Response =
        serde_json::from_value(json!({})).unwrap();
    assert!(response.analytics_sales_and_traffic_2024_04_24.is_none());
}

#[test]
fn listings_operations_roundtrip_and_require_their_branch_fields() {
    for message in [
        json!({"messageId":1,"sku":"sku","operationType":"DELETE"}),
        json!({"messageId":2,"sku":"sku","operationType":"PARTIAL_UPDATE","productType":"PRODUCT","attributes":{"future":[{"value":true}]}}),
        json!({"messageId":3,"sku":"sku","operationType":"PATCH","productType":"PRODUCT","patches":[{"op":"replace","path":"/attributes/price","value":[{"value":123}]}]}),
    ] {
        let parsed: feeds::listings_feed_message_schema::Feed =
            serde_json::from_value(message.clone()).unwrap();
        assert_eq!(serde_json::to_value(parsed).unwrap(), message);
        let full = json!({"header":{"sellerId":"seller","version":"2.0"},"messages":[message]});
        let parsed: feeds::listings_feed_schema::Feed =
            serde_json::from_value(full.clone()).unwrap();
        assert_eq!(serde_json::to_value(parsed).unwrap(), full);
    }
    for message in [
        json!({"messageId":1,"sku":"sku","operationType":"UPDATE","productType":"PRODUCT"}),
        json!({"messageId":1,"sku":"sku","operationType":"PATCH","productType":"PRODUCT"}),
        json!({"messageId":1,"sku":"sku","operationType":"DELETE","attributes":{"price":1}}),
        json!({"messageId":1,"sku":"sku","operationType":"PARTIAL_UPDATE","productType":"PRODUCT","attributes":{"price":1},"requirements":"LISTING"}),
    ] {
        assert!(
            serde_json::from_value::<feeds::listings_feed_message_schema::Feed>(message.clone())
                .is_err(),
            "invalid message accepted: {message}"
        );
        let full = json!({"header":{"sellerId":"seller","version":"2.0"},"messages":[message]});
        assert!(serde_json::from_value::<feeds::listings_feed_schema::Feed>(full).is_err());
    }
}

#[test]
fn optional_tax_messages_require_an_english_entry_when_present() {
    use notifications::tax_invoice_issuance_eligibility_status_change::Payload;
    let mut value = json!({"marketplaceId":"market","operation":"inbound","status":"BLOCKED"});
    assert!(
        serde_json::from_value::<Payload>(value.clone())
            .unwrap()
            .message
            .is_none()
    );
    value["message"] =
        json!([{"locale":"en-US","text":"Blocked"},{"locale":"future-locale","text":"Other"}]);
    assert_eq!(
        serde_json::from_value::<Payload>(value.clone())
            .unwrap()
            .message
            .unwrap()
            .len(),
        2
    );
    value["message"] = json!([{"locale":"pt-BR","text":"Blocked"}]);
    assert!(serde_json::from_value::<Payload>(value).is_err());
}

#[test]
fn uppercase_notification_patch_allows_missing_offer_and_summary_fields() {
    let mut value: Value = serde_json::from_str(include_str!(
        "fixtures/supplemental/AnyOfferChangedNotification.json"
    ))
    .unwrap();
    let summary = value
        .pointer_mut("/Payload/AnyOfferChangedNotification/Summary")
        .unwrap()
        .as_object_mut()
        .unwrap();
    summary.retain(|key, _| {
        [
            "NumberOfOffers",
            "LowestPrices",
            "NumberOfBuyBoxEligibleOffers",
        ]
        .contains(&key.as_str())
    });
    for offer in value
        .pointer_mut("/Payload/AnyOfferChangedNotification/Offers")
        .unwrap()
        .as_array_mut()
        .unwrap()
    {
        offer["IsFulfilledByAmazon"] = json!(true);
    }
    let offer = value
        .pointer_mut("/Payload/AnyOfferChangedNotification/Offers/0")
        .unwrap()
        .as_object_mut()
        .unwrap();
    offer.retain(|key, _| {
        [
            "SellerId",
            "SubCondition",
            "ShippingTime",
            "ListingPrice",
            "Shipping",
            "IsFulfilledByAmazon",
        ]
        .contains(&key.as_str())
    });
    let parsed: notifications::any_offer_changed::Notification =
        serde_json::from_value(value.clone()).unwrap();
    let encoded = serde_json::to_value(parsed).unwrap();
    assert!(encoded.get("Payload").is_some());
    assert!(encoded.get("payload").is_none());
    assert!(
        encoded
            .pointer("/Payload/AnyOfferChangedNotification/Summary/BuyBoxPrices")
            .is_none()
    );
}

#[test]
fn lowercase_flat_notification_patch_and_root_ref_preserve_envelope() {
    let mut value: Value = serde_json::from_str(include_str!(
        "fixtures/supplemental/PricingHealthNotification.json"
    ))
    .unwrap();
    value
        .pointer_mut("/payload/offerChangeTrigger")
        .unwrap()
        .as_object_mut()
        .unwrap()
        .remove("timeOfOfferChange");
    let parsed: notifications::pricing_health::Notification =
        serde_json::from_value(value).unwrap();
    let encoded = serde_json::to_value(parsed).unwrap();
    assert_eq!(encoded["notificationType"], "PRICING_HEALTH");
    assert!(
        encoded
            .pointer("/payload/offerChangeTrigger/timeOfOfferChange")
            .is_none()
    );
}

#[test]
fn data_kiosk_lists_keep_nullable_elements_and_partial_objects() {
    use data_kiosk::sales_and_traffic20240424::AnalyticsSalesAndTraffic20240424;
    let value: AnalyticsSalesAndTraffic20240424 = serde_json::from_value(json!({
        "salesAndTrafficByAsin":[null,{"childAsin":"ASIN","sales":{"unitsOrdered":9007199254740993_i64}}]
    })).unwrap();
    let entries = value.sales_and_traffic_by_asin.unwrap();
    assert!(entries[0].is_none());
    let selected = entries[1].as_ref().unwrap();
    assert_eq!(selected.child_asin.as_deref(), Some("ASIN"));
    assert_eq!(
        selected.sales.as_ref().unwrap().units_ordered,
        Some(9007199254740993)
    );
    assert!(selected.traffic.is_none());
    assert!(
        serde_json::from_value::<AnalyticsSalesAndTraffic20240424>(
            json!({"salesAndTrafficByAsin":null})
        )
        .unwrap()
        .sales_and_traffic_by_asin
        .is_none()
    );
}
