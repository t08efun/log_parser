# frozen_string_literal: true

# For output modifying
module ANSI
  def self.underline(str)
    "\e[0;4m#{str}\e[1;0m"
  end

  def self.white(str)
    "\e[0;97m#{str}\e[1;0m"
  end

  def self.green(str)
    "\e[0;92m#{str}\e[0;97m"
  end

  def self.red(str)
    "\033[91m#{str}\033[39m"
  end
end
