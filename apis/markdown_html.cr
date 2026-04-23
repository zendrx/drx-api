require "markd"

module Api
  class MarkdownToHtml
    def self.run(markdown_text : String)
      begin
        # Options for a "Pro" experience:
        # - smart: handles curly quotes and dashes
        # - safe: filters out potentially dangerous HTML
        options = Markd::Options.new(
          smart: true,
          safe: true
        )

        # Markd automatically handles GFM features like tables and task lists
        html_output = Markd.to_html(markdown_text, options)

        {
          "success"     => "true",
          "html"        => html_output,
          "stats"       => {
            "chars" => markdown_text.size,
            "words" => markdown_text.split.size
          },
          "attribution" => "drx_api"
        }
      rescue e : Exception
        {
          "success" => "false",
          "error"   => e.message.to_s
        }
      end
    end
  end
end
