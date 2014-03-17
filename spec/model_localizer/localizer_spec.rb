require "spec_helper"

describe "localizer" do
  describe "localizer with default model" do

    before :each do
      Localizer.delete_all
      User.delete_all
      I18n.locale = 'en'
    end

    let(:user) {User.create(name: 'Leo')}

    it "user name with default locale" do
      user.name.should == 'Leo'
    end

    it "user name with specific locale" do
      user.set_name("ole", "zh-CN")
      user.get_name("zh-CN").should == 'ole'
    end

    it "user name with current locale" do
      user.set_name("ole", "zh-CN")
      I18n.locale = "zh-CN"
      user.name.should == 'ole'
    end

    it "user name with current locale, while current locale is nil, return default" do
      I18n.locale = "zh-CN"
      user.name.should == 'Leo'
    end

  end

  describe "localizer with specific model" do

    before :each do
      Customer.delete_all
      Translation.delete_all
      I18n.locale = 'en'
    end

    let(:customer) {Customer.create(name: 'Leo')}

    it "customer name with default locale" do
      customer.name.should == 'Leo'
    end

    it "customer name with specific locale" do
      customer.set_name("ole", "zh-CN")
      customer.get_name("zh-CN").should == 'ole'
    end

    it "customer name with current locale" do
      customer.set_name("ole", "zh-CN")
      I18n.locale = "zh-CN"
      customer.name.should == 'ole'
    end

    it "customer name with current locale, while current locale is nil, return default" do
      customer.get_name("zh-CN").should == 'Leo'
      I18n.locale = "zh-CN"
      customer.name.should == 'Leo'
    end
  end

  describe "localizer with many columns" do

    before :each do
      Task.delete_all
      Translation.delete_all
      I18n.locale = 'en'
    end

    let(:task) {Task.create(title: 'hello', description: 'world')}

    it "title and description with default locale" do
      task.title.should == 'hello'
      task.description.should == 'world'
    end

    it "title and description with specific locale" do
      task.set_title("kkk", "zh-CN")
      task.get_title("zh-CN").should == 'kkk'
    end

    it "title and description with current locale" do
      task.set_description("ttt", "zh-CN")
      I18n.locale = "zh-CN"
      task.description.should == 'ttt'
    end

    it "title and description with current locale, while current locale is nil, return default" do
      task.get_title("zh-CN").should == 'hello'
      I18n.locale = "zh-CN"
      task.title.should == 'hello'
    end

  end
end