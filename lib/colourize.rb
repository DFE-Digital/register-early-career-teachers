module Colourize
  MODES = {
    clear: 0,
    bold: 1,
    italic: 3,
    underline: 4,
  }.freeze

  # ANSI sequence colors
  COLOURS = {
    black: 30,
    red: 31,
    green: 32,
    yellow: 33,
    blue: 34,
    magenta: 35,
    cyan: 36,
    white: 37,
  }.freeze

  def self.text(text, colour, modes = :bold)
    mode_opts = MODES.values_at(*Array(modes).compact_blank).join(";")

    opts = [
      COLOURS.fetch(colour),
      mode_opts,
    ].compact_blank.join(";")

    "\e[#{opts}m#{text}\e[0m"
  end
end
