module Hdo
  module Stats
    class Leaderboard
      attr_reader :by_party, :by_key

      def initialize(issues)
        parties = Party.all

        @by_party = Hash.new { |hash, key| hash[key] = Hash.new(0) }
        @by_key = Hash.new { |hash, key| hash[key] = Hash.new(0) }

        issues.each do |issue|
          acc = issue.accountability
          parties.each do |party|
            @by_party[party][acc.key_for(party)] += 1
            @by_key[acc.key_for(party)][party] += 1
          end
        end
      end

      def thermo
        @thermo ||= 100 * @by_key[:kept].values.sum.to_f / (@by_key[:kept].values.sum + @by_key[:broken].values.sum)
      end
    end
  end
end