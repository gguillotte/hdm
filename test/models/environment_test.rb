require 'test_helper'

class EnvironmentTest < ActiveSupport::TestCase
  setup do
    Settings.puppet_db.enabled = false
  end

  test "list the environments" do
    assert_equal ['development', 'hdm', 'test'], Environment.all
  end

  test "create development environment" do
    assert Environment.new('development')
  end

  test "raise error for non existing environment" do
    err = assert_raises(Environment::NotFound) { Environment.new('unknown') }
    assert_match("Environment 'unknown' does not exist", err.message)
  end

  test "when PuppetDB is enabled" do
    Settings.puppet_db.enabled = true
    mock = Minitest::Mock.new
    mock.expect :apply, ['foo']

    PuppetDBClient.stub(:environments, mock) do
      environments = Environment.all
      assert_equal ['foo'], environments.apply
    end

    assert mock.verify
  end
end
