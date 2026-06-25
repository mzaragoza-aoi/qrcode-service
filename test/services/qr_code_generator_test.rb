require "test_helper"

class QrCodeGeneratorTest < ActiveSupport::TestCase
  test "returns an svg qr code for text" do
    svg = QrCodeGenerator.call("https://example.com")

    assert_includes svg, "<svg"
    assert_includes svg, "path"
  end

  test "rejects blank text" do
    error = assert_raises(QrCodeGenerator::Error) do
      QrCodeGenerator.call("")
    end

    assert_equal "Text can't be blank", error.message
  end
end
