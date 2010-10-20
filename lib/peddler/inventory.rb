module Peddler
  module Inventory
    module Queue
      # Returns number of inventory uploads queued at Amazon
      def self.count(transport)
        transport.legacize_request
        transport.path << 'manual-reports/get-pending-uploads-count'
        res = transport.execute_request
        if res =~ /^<PendingUploadsCount>(.*)<\/PendingUploadsCount>$/
          $1.to_i
        else
          nil
        end
      end
    end

    # This is an inventory batch.
    class Batch
      attr_reader :id
      attr_accessor :batch

      def initialize(transport)
        @transport = transport
        @batch = []
      end

      # Uploads batch to Amazon.
      def upload(params={})
        raise PeddlerError.new('Batch already uploaded') unless @id.nil?
        @transport.legacize_request
        @transport.path << 'catalog-upload/'

        case params[:method].to_s
        when 'modify'
          @transport.path << 'modify-only'
          @transport.body = file_content(:short)
        when 'purge'
          @transport.path << 'purge-replace'
          @transport.body = file_content
        else
          @transport.path << 'add-modify-delete'
          @transport.body = file_content
        end
        params.delete(:method)

        params = defaultize(params)
        @transport.headers.merge!(params)
        res = @transport.execute_request

        if res =~ /^<BatchID>(.*)<\/BatchID>$/
          @id = $1
        else
          @id = 0
        end
        true
      end

      # Returns upload file string.
      def file_content(type=:long)
        case type
        when :long
          out = "product-id\tproduct-id-type\titem-condition\tprice\tsku\tquantity\tadd-delete\twill-ship-internationally\texpedited-shipping\titem-note\titem-is-marketplace\tfulfillment-center-id\titem-name\titem-description\tcategory1\timage-url\tshipping-fee\tbrowse-path\tstorefront-feature\tboldface\tasin1\tasin2\tasin3\r\n"
          @batch.each{ |item| out << item.to_s }
        when :short
          out = "sku\tprice\tquantity\r\n"
          @batch.each{ |item| out << item.to_s(:short) }
        end
        out
      end

      # Adds an item to inventory.
      def <<(item)
        @batch << item
      end

      private

      def defaultize(params)
        params = {
          :upload_for         => 'Marketplace',
          :file_format        => 'TabDelimited',
          :asin_match_create  => 'Y',
          :asinate            => 'Y',
          :batch_id           => 'Y',
          :email              => 'Y'
        }.merge(params)

        # Some Amazon dimwit figured he'd rather not camelize this one
        if params[:enable_expedited_shipping]
          params['enable-expedited-shipping'] = params[:enable_expedited_shipping]
          params.delete(:enable_expedited_shipping)
        else
          params['enable-expedited-shipping'] = 'Y'
        end

        params
      end
    end

    # This is an inventory item.
    class Item
      attr_accessor :product_id,
                    :product_id_type,
                    :item_condition,
                    :price,
                    :sku,
                    :quantity,
                    :add_delete,
                    :will_ship_internationally,
                    :expedited_shipping,
                    :item_note,
                    :item_is_marketplace,
                    :fulfillment_center_id,
                    :item_name,
                    :item_description,
                    :category1,
                    :image_url,
                    :shipping_fee,
                    :browse_path,
                    :storefront_feature,
                    :boldface,
                    :asin1,
                    :asin2,
                    :asin3

      def initialize(params={})
        params.each_pair{ |key, value| send("#{key.to_s}=", value) }
      end

      def to_s(type=:long)
        case type
        when :long
          "#{self.product_id}\t#{self.product_id_type}\t#{self.item_condition}\t#{self.price}\t#{self.sku}\t#{self.quantity}\t#{self.add_delete}\t#{self.will_ship_internationally}\t#{self.expedited_shipping}\t#{self.item_note}\t#{self.item_is_marketplace}\t#{self.fulfillment_center_id}\t#{self.item_name}\t#{self.item_description}\t#{self.category1}\t#{self.image_url}\t#{self.shipping_fee}\t#{self.browse_path}\t#{self.storefront_feature}\t#{self.boldface}\t#{self.asin1}\t#{self.asin2}\t#{self.asin3}\r\n"
        when :short
          "#{self.sku}\t#{self.price}\t#{self.quantity}\r\n"
        end
      end
    end
  end
end
