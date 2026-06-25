class QrCodeGenerator
  Error = Class.new(StandardError)

  def self.call(text)
    new(text).call
  end

  def initialize(text)
    @text = text.to_s
  end

  def call
    raise Error, "Text can't be blank" if text.blank?

    RQRCode::QRCode.new(text).as_svg(
      color: "000",
      fill: "fff",
      module_size: 8,
      shape_rendering: "crispEdges",
      standalone: true,
      use_path: true
    )
  rescue Error
    raise
  rescue StandardError => e
    raise Error, e.message
  end

  private

  attr_reader :text
end
