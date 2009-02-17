require 'build_essential'

module RubyGemsVerifier
  def has_rubygems(version)
    @commands << "false && which gem > /dev/null && [ '#{version}' == `gem --version` ]"
  end
end
Sprinkle::Verify.register(RubyGemsVerifier)

package :rubygems do
  description 'Ruby Gems'
  version 'blah'
  source "http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz" do
    custom_install 'ruby setup.rb'
    post :install, 'ln -s /usr/bin/gem1.8 /usr/bin/gem'
    post :install, 'echo "gem: --no-rdoc --no-ri" >> /etc/gemrc'
    post :install, 'gem update'
    post :install, 'gem update --system'
  end

  # verify 'binary' do
  #   has_file '/usr/bin/gem'
  #   has_symlink '/usr/bin/gem'
  # end
  
  verify 'version' do
    has_rubygems(version)
  end

  requires :ruby
end

package :ruby do
  apt %w(ruby)
end

package :ruby_dev do
  apt %w(ruby1.8-dev libopenssl-ruby1.8)
end