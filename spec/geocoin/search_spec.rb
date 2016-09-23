RSpec.describe Geocoin::Search do
  let(:search) { described_class.new(url: url, page_limit: 2) }
  let(:url) { "https://www.leboncoin.fr/ventes_immobilieres/offres/ile_de_france/" }

  describe "fetching the search's results", vcr: {cassette_name: "Geocoin_Search/results"} do
    subject(:results) { search.results }

    it { is_expected.to be_an Array }

    it "contains 2 times 35 elements" do
      binding.pry
      expect(results.size).to eq 70
    end
  end
end
