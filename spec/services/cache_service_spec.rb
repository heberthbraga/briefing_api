require "rails_helper"

describe CacheService, type: :service do
  let(:key) { "test_key" }
  let(:value) { "test_value" }
  let(:mock_cache_store) { instance_double("ActiveSupport::Cache::Store") }

  before do
    allow(Rails).to receive(:cache).and_return(mock_cache_store)
  end

  describe "#initialize" do
    it "sets enabled to true when REDIS_ENABLED is 'true'" do
      stub_const("ENV", ENV.to_h.merge("REDIS_ENABLED" => "true"))
      service = CacheService.new
      expect(service.send(:enabled)).to eq(true)
    end

    it "sets enabled to false when REDIS_ENABLED is not 'true'" do
      stub_const("ENV", ENV.to_h.merge("REDIS_ENABLED" => "false"))
      service = CacheService.new
      expect(service.send(:enabled)).to eq(false)
    end

    it "sets expires_in from ENV with default fallback" do
      stub_const("ENV", ENV.to_h.merge("REDIS_TTL" => 3600))
      service = CacheService.new
      expect(service.send(:expires_in)).to eq(3600)
    end
  end

  describe "#fetch" do
    context "when enabled is true" do
      before do
        stub_const("ENV", ENV.to_h.merge("REDIS_ENABLED" => "true"))
      end

      it "logs errors and returns block result on Redis failure" do
        allow(mock_cache_store).to receive(:fetch).and_raise(Redis::BaseError, "Error")
        expect(Rails.logger).to receive(:error).with(/Redis error: Error/)
        service = CacheService.new
        result = service.fetch(key) { value }
        expect(result).to eq(value)
      end
    end

    context "when enabled is false" do
      before do
        stub_const("ENV", ENV.to_h.merge("REDIS_ENABLED" => "false"))
      end

      it "returns the block result without accessing the cache" do
        expect(mock_cache_store).not_to receive(:fetch)
        service = CacheService.new
        result = service.fetch(key) { value }
        expect(result).to eq(value)
      end
    end
  end

  describe "#read" do
    context "when enabled is true" do
      before do
        stub_const("ENV", ENV.to_h.merge("REDIS_ENABLED" => "true"))
      end

      it "reads data from cache" do
        allow(mock_cache_store).to receive(:read).with(key).and_return(value)
        service = CacheService.new
        result = service.read(key)
        expect(result).to eq(value)
      end

      it "logs errors and returns nil on Redis failure" do
        allow(mock_cache_store).to receive(:read).and_raise(Redis::BaseError, "Error")
        expect(Rails.logger).to receive(:error).with(/Redis error on read: Error/)
        service = CacheService.new
        result = service.read(key)
        expect(result).to be_nil
      end
    end

    context "when enabled is false" do
      before do
        stub_const("ENV", ENV.to_h.merge("REDIS_ENABLED" => "false"))
      end

      it "returns nil without accessing the cache" do
        expect(mock_cache_store).not_to receive(:read)
        service = CacheService.new
        result = service.read(key)
        expect(result).to be_nil
      end
    end
  end

  describe "#write" do
    context "when enabled is true" do
      before do
        stub_const("ENV", ENV.to_h.merge("REDIS_ENABLED" => "true"))
      end

      it "writes data to cache" do
        allow(mock_cache_store).to receive(:write).with(key, value, expires_in: 1.hour).and_return(true)
        service = CacheService.new
        result = service.write(key, value)
        expect(result).to eq(true)
      end

      it "logs errors and returns the value on Redis failure" do
        allow(mock_cache_store).to receive(:write).and_raise(Redis::BaseError, "Error")
        expect(Rails.logger).to receive(:error).with(/Redis error on write: Error/)
        service = CacheService.new
        result = service.write(key, value)
        expect(result).to eq(value)
      end
    end

    context "when enabled is false" do
      before do
        stub_const("ENV", ENV.to_h.merge("REDIS_ENABLED" => "false"))
      end

      it "returns the value without accessing the cache" do
        expect(mock_cache_store).not_to receive(:write)
        service = CacheService.new
        result = service.write(key, value)
        expect(result).to eq(value)
      end
    end
  end

  describe "#delete" do
    context "when enabled is true" do
      before do
        stub_const("ENV", ENV.to_h.merge("REDIS_ENABLED" => "true"))
      end

      it "deletes data from cache" do
        allow(mock_cache_store).to receive(:delete).with(key).and_return(true)
        service = CacheService.new
        result = service.delete(key)
        expect(result).to eq(true)
      end

      it "logs errors and returns nil on Redis failure" do
        allow(mock_cache_store).to receive(:delete).and_raise(Redis::BaseError, "Error")
        expect(Rails.logger).to receive(:error).with(/Redis error on delete: Error/)
        service = CacheService.new
        result = service.delete(key)
        expect(result).to be_nil
      end
    end

    context "when enabled is false" do
      before do
        stub_const("ENV", ENV.to_h.merge("REDIS_ENABLED" => "false"))
      end

      it "returns nil without accessing the cache" do
        expect(mock_cache_store).not_to receive(:delete)
        service = CacheService.new
        result = service.delete(key)
        expect(result).to be_nil
      end
    end
  end
end
