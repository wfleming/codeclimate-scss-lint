require "test_helper"

class TestCodeclimateReporter < Minitest::Test
  def test_report_lints_returns_correct_json
    lint = stub('Lint',
      linter: stub(name: 'BorderZero'),
      location: stub(line: 1, column: 5, length: 2),
      description: "`0px` should be written without units as `0`",
      filename: "test.scss"
    )
    output = SCSSLint::Reporter::CodeclimateReporter.new([lint], []).report_lints
    output_hash = JSON.parse(output)
    assert_equal "issue", output_hash["type"]
    assert_equal "BorderZero", output_hash["check_name"]
    assert_equal "`0px` should be written without units as `0`", output_hash["description"]
    assert_equal ["Style"], output_hash["categories"]
    assert_equal 50_000, output_hash["remediation_points"]
    assert_equal "test.scss", output_hash["location"]["path"]
    start_position = {"line"=>1, "column"=>5}
    end_position = {"line"=>1, "column"=>6}
    assert_equal start_position, output_hash["location"]["positions"]["begin"]
    assert_equal end_position, output_hash["location"]["positions"]["end"]
  end
end
