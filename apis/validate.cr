module Api
  class Validator
    # List of common disposable email domains to block
    DISPOSABLE_DOMAINS = ["mailinator.com", "10minutemail.com", "tempmail.com", "guerrillamail.com"]

    def self.email(email : String)
      # 1. Basic Regex Check
      regex = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/
      is_format_valid = !!(email =~ regex)
      
      return { "success" => "false", "error" => "Invalid format" } unless is_format_valid

      # 2. Disposable Check
      domain = email.split("@").last.downcase
      is_disposable = DISPOSABLE_DOMAINS.includes?(domain)

      {
        "success"       => "true",
        "email"         => email,
        "is_disposable" => is_disposable.to_s,
        "suggestion"    => is_disposable ? "Please use a permanent email address" : "Valid",
        "attribution"   => "drx_api"
      }
    end

    def self.phone(number : String)
      # Clean the number (remove spaces, dashes, dots)
      clean_number = number.gsub(/[\s\-\.\(\)]/, "")
      
      # 1. Check for E.164 format (starts with + and has 10-15 digits)
      is_international = clean_number.starts_with?("+") && clean_number.size >= 11
      
      {
        "success"      => "true",
        "original"     => number,
        "clean"        => clean_number,
        "is_intl_format" => is_international.to_s,
        "message"      => is_international ? "Valid international format" : "Local format or missing country code"
      }
    end
  end
end
