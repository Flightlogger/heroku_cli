module HerokuCLI
  class PG < Base
    class Database
      attr_reader :url_name, :info

      def initialize(url_name, info)
        @url_name = url_name
        @info = {}
        info.each do |line|
          k = line.split(':')[0].strip
          v = line.split(':')[1..-1].join(':').strip
          next if k.nil? || v.nil?
          @info[k] = v
        end
      end

      def to_s
        result = ["=== #{url_name}"]
        result.concat(info.map { |k, v| format("%-22.22s %s", "#{k}:", v)})
        result.concat([''])
        result.join("\n")
      end

      def name
        @name ||= @url_name.gsub(/_URL\z/, '')
      end

      def plan
        info['Plan']
      end

      def data_size
        info['Data Size']
      end

      def status
        info['Status']
      end

      def tables
        info['Tables'].match(/(\d+)/)[0]&.to_i || 0
      end

      def version
        Gem::Version.new(info['PG Version'])
      end

      def followers
        info['Followers']
      end

      def main?
        !fork?
      end

      def fork?
        info.key?('Following')
      end

      def behind?
        behind_by.positive?
      end

      def behind_by
        info['Behind By']&.match(/(\d+)/)&.first&.to_i || 0
      end

      def region
        info['Region']
      end

      def add_on
        info['Add-on']
      end
    end
  end
end
