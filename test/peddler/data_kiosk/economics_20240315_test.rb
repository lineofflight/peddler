# frozen_string_literal: true

require "helper"

module Peddler
  module DataKiosk
    class Economics20240315Test < Minitest::Test
      include FeatureHelpers

      def test_economics_query
        query = <<~GRAPHQL
          query {
            analytics_economics_2024_03_15 {
              economics(
                startDate: "2025-01-01"
                endDate: "2025-06-30"
                marketplaceIds: ["ATVPDKIKX0DER"]
                aggregateBy: { productId: MSKU, date: WEEK }
                includeComponentsForFeeTypes: [FBA_FULFILLMENT_FEE, FBA_STORAGE_FEE]
              ) {
                marketplaceId
                startDate
                endDate
                parentAsin
                msku
                fnsku
                childAsin
                sales {
                  orderedProductSales {
                    amount
                    currencyCode
                  }
                  refundedProductSales {
                    amount
                    currencyCode
                  }
                  netProductSales {
                    amount
                    currencyCode
                  }
                  averageSellingPrice {
                    amount
                    currencyCode
                  }
                  unitsOrdered
                  unitsRefunded
                  netUnitsSold
                }
                fees {
                  feeTypeName
                  charges {
                    identifier
                    startDate
                    endDate
                    aggregatedDetail {
                      amount {
                        amount
                        currencyCode
                      }
                      promotionAmount {
                        amount
                        currencyCode
                      }
                      taxAmount {
                        amount
                        currencyCode
                      }
                      totalAmount {
                        amount
                        currencyCode
                      }
                      quantity
                      amountPerUnit {
                        amount
                        currencyCode
                      }
                      amountPerUnitDelta {
                        amount
                        currencyCode
                      }
                    }
                    components {
                      name
                      aggregatedDetail {
                        amount {
                          amount
                          currencyCode
                        }
                        totalAmount {
                          amount
                          currencyCode
                        }
                        quantity
                        amountPerUnit {
                          amount
                          currencyCode
                        }
                      }
                    }
                  }
                }
                ads {
                  adTypeName
                  charge {
                    amount {
                      amount
                      currencyCode
                    }
                    totalAmount {
                      amount
                      currencyCode
                    }
                  }
                }
                cost {
                  costOfGoodsSold {
                    amount
                    currencyCode
                  }
                  miscellaneousCost {
                    amount
                    currencyCode
                  }
                  fbaCost {
                    shippingToAmazonCost {
                      amount
                      currencyCode
                    }
                  }
                  mfnCost {
                    fulfillmentCost {
                      amount
                      currencyCode
                    }
                    storageCost {
                      amount
                      currencyCode
                    }
                  }
                }
                netProceeds {
                  total {
                    amount
                    currencyCode
                  }
                  perUnit {
                    amount
                    currencyCode
                  }
                }
              }
            }
          }
        GRAPHQL

        response = api.create_query({ query: })
        query_id = response.parse.query_id

        response = api.get_query(query_id)
        data_document_id = response.parse.data_document_id

        url = api.get_document(data_document_id).parse.document_url
        data = client.download_document(replayed(url)).each_jsonl.map do |payload|
          DataKiosk::Economics20240315::Economics.parse(payload)
        end

        refute_empty(data)
      end

      private

      def api_name
        "data_kiosk_2023_11_15"
      end
    end
  end
end
