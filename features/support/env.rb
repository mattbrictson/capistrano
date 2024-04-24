PROJECT_ROOT = File.expand_path("../../../", __FILE__)
VAGRANT_ROOT = File.join(PROJECT_ROOT, "spec/support")
VAGRANT_BIN = ENV["VAGRANT_BIN"] || "vagrant"

require_relative "../../spec/support/test_app"

# TODO: remove file?
