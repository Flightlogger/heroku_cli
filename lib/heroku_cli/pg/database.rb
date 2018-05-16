module HerokuCLI
  class PG < Base
    class Database
      attr_reader :url_names, :info

      def initialize(info)
        @url_names = info.shift
        @url_names = @url_names.sub('=== ','').split(',').map(&:strip)
        @info = {}
        info.each do |line|
          k = line.split(':')[0].strip
          v = line.split(':')[1..-1].join(':').strip
          next if k.nil? || v.nil?
          @info[k] = v
        end
      end

      def url_name
        @url_names.first
      end

      def to_s
        result = ["=== #{@url_names.join(', ')}"]
        result.concat(info.map { |k, v| format("%-22.22s %s", "#{k}:", v)})
        result.concat([''])
        result.join("\n")
      end

      def name
        @name ||= url_name.gsub(/_URL\z/, '')
      end

      def plan
        info['Plan'].gsub(' ', '-').downcase
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

      def forks
        info['Forks'].split(',').map(&:strip)
      end

      def forked_from
        info['Forked From'].split(',').map(&:strip)
      end

      def following
        info['Following'].strip
      end

      def main?
        @url_names.include?('DATABASE_URL')
      end

      def fork?
        info.key?('Forks')
      end

      def follower?
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

      def resource_name
        info['Add-on']
      end
    end
  end
end
