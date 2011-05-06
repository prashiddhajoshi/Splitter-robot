# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{flvtool2}
  s.version = "1.0.6"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Norman Timmler"]
  s.cert_chain = nil
  s.date = %q{2007-02-09}
  s.default_executable = %q{flvtool2}
  s.description = %q{FLVTool2 is a manipulation tool for Macromedia Flash Video files (FLV). It can calculate a lot of meta data, insert an onMetaData tag, cut FLV files, add cue points (onCuePoint), show the FLV structure and print meta data information in XML or YAML.}
  s.email = %q{norman.timmler@inlet-media.de}
  s.executables = ["flvtool2"]
  s.files = ["bin/flvtool2"]
  s.homepage = %q{http://www.inlet-media.de/flvtool2}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = %q{flvtool2}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Flash video (FLV) manipulation tool}

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
