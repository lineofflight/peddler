use peddler::{data_kiosk, feeds, notifications, reports};
use serde_json::{Value, json};

#[test]
fn listings_update_keeps_dynamic_attributes_and_large_numbers() {
    let input: Value = serde_json::from_str(r#"{"header":{"sellerId":"seller","version":"2.0"},"messages":[{"messageId":1,"sku":"sku","operationType":"UPDATE","productType":"PRODUCT","attributes":{"price":9007199254740993.1234567890123456789}}]}"#).unwrap();
    let feed: feeds::listings_feed_schema::Feed = serde_json::from_value(input.clone()).unwrap();
    assert_eq!(serde_json::to_value(feed).unwrap(), input);
}

#[test]
fn shipment_example_retains_typed_payload_and_extension_fields() {
    let source: Value = serde_json::from_str(include_str!(
        "fixtures/supplemental/ShipmentTrackingMilestoneChangedNotification.json"
    ))
    .unwrap();
    let mut input = source["examples"][0].clone();
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
fn optional_report_numbers_are_not_defaulted_and_arrays_stay_typed() {
    let metrics: reports::end_user_data::AsinMetrics = serde_json::from_value(json!({"asin":"ASIN","endDate":"2026-01-02","startDate":"2026-01-01","marketplaceId":"market"})).unwrap();
    assert!(metrics.gms.is_none());
    assert!(metrics.page_views.is_none());
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
    let source: Value = serde_json::from_str(include_str!(
        "fixtures/supplemental/AnyOfferChangedNotification.json"
    ))
    .unwrap();
    let mut value = source["examples"][0].clone();
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
    let source: Value = serde_json::from_str(include_str!(
        "fixtures/supplemental/PricingHealthNotification.json"
    ))
    .unwrap();
    let mut value = source["examples"][0].clone();
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

#[test]
fn b2b_root_dialect_and_patch_allow_partial_feedback_and_prime_fields() {
    use notifications::b2b_any_offer_changed as model;
    serde_json::from_value::<model::ShipsFrom>(json!({})).unwrap();
    serde_json::from_value::<model::PrimeInformation>(json!({})).unwrap();
    serde_json::from_value::<model::SellerFeedbackRating>(json!({"FeedbackCount":0})).unwrap();
    serde_json::from_value::<model::OfferCount>(
        json!({"Condition":"New","FulfillmentChannel":"Amazon"}),
    )
    .unwrap();
    let summary: model::Summary = serde_json::from_value(
        json!({"NumberOfOffers":[],"BuyBoxEligibleOffers":[],"LowestPrices":[]}),
    )
    .unwrap();
    assert!(summary.buy_box_prices.is_none());
    let notification: model::Notification = serde_json::from_value(json!({
        "NotificationVersion":"1.0","NotificationType":"B2B_ANY_OFFER_CHANGED","PayloadVersion":"1.0","EventTime":"2026-01-01",
        "NotificationMetadata":{"ApplicationId":"app","SubscriptionId":"sub","PublishTime":"2026-01-01","NotificationId":"id"},
        "Payload":{"B2BAnyOfferChangedNotification":{"SellerId":"seller","OfferChangeTrigger":{"MarketplaceId":"market","ASIN":"asin","ItemCondition":"New","TimeOfOfferChange":"2026-01-01"},"Offers":[],"Summary":{"NumberOfOffers":[],"BuyBoxEligibleOffers":[],"LowestPrices":[]}}}
    })).unwrap();
    assert_eq!(notification.notification_type, "B2B_ANY_OFFER_CHANGED");
}

#[test]
fn fee_promotion_patch_keeps_identifier_and_discount_fields_optional() {
    let source: Value = serde_json::from_str(include_str!(
        "fixtures/supplemental/FeePromotionNotification.json"
    ))
    .unwrap();
    let mut value = source["examples"][0].clone();
    value
        .pointer_mut("/Payload/FeePromotionNotification/Identifiers/0/IdentifierValues/0")
        .unwrap()
        .as_object_mut()
        .unwrap()
        .remove("IdentifierValueFriendlyName");
    value
        .pointer_mut("/Payload/FeePromotionNotification/PromotionInformation/0")
        .unwrap()
        .as_object_mut()
        .unwrap()
        .retain(|key, _| ["FeeType", "FeeDiscountType"].contains(&key.as_str()));
    value
        .pointer_mut(
            "/Payload/FeePromotionNotification/PromotionInformation/1/FeesEstimate/FeeDetails/0",
        )
        .unwrap()
        .as_object_mut()
        .unwrap()
        .remove("TaxAmount");
    let parsed: notifications::fee_promotion::Notification =
        serde_json::from_value(value.clone()).unwrap();
    let encoded = serde_json::to_value(parsed).unwrap();
    assert_eq!(encoded, value);
}
