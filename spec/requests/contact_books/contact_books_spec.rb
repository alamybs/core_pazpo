require 'rails_helper'

RSpec.describe "Api::V1::ContactBooks", type: :request do
  describe "[POST] Endpoint /" do
    before :each do
      @user  = FactoryGirl.create(:user)
    end
    it "should returns 200 with valid params when success sync phone books" do
      params = {
        contact_book: {
          contacts: [
                      {
                        name:         @user.name,
                        email:        @user.email,
                        phone_number: @user.phone_number,
                      },
                      {
                        name:         "satu",
                        email:        "satu@pazpo.id",
                        phone_number: "+6285643736789",
                      },
                      {
                        name:         "dua",
                        email:        "dua@pazpo.id",
                        phone_number: "+6285643736456",
                      },
                      {
                        name:         "tiga",
                        email:        "tiga@pazpo.id",
                        phone_number: "+6285643736123",
                      }
                    ]
        }
      }
      post "/contact_books/",
           params:  params,
           headers: {'Authorization'  => @user.authentication_token,
                     'Accept-Version' => 'v1'}
      cr = ContactRelation.all
      cb = ContactBook.all
      expect(response.status).to eq(201)

      expect(cr.size).to eq(4)
      expect(cr.where(status: :owner).size).to eq(1)
      expect(cr.where(status: :friend).size).to eq(3)

      expect(cb.size).to eq(4)
      expect(JSON.parse(response.body)['data']).to eq({"messages" => "Success sync contact."})
    end
    it "should returns 200 with valid params when success sync phone books with 3 user" do
      @user_2 = FactoryGirl.create(:user_2)
      @user_3 = FactoryGirl.create(:user_3)
      params = {
        contact_book: {
          contacts: [
                      {
                        name:         @user.name,
                        email:        @user.email,
                        phone_number: @user.phone_number,
                      },
                      {
                        name:         "satu",
                        email:        "satu@pazpo.id",
                        phone_number: "+6285643736789",
                      },
                      {
                        name:         "dua",
                        email:        "",
                        phone_number: "+6285643736456",
                      },
                      {
                        name:         "tiga",
                        email:        "tiga@pazpo.id",
                        phone_number: "+6285643736123",
                      }
                    ]
        }
      }
      post "/contact_books/",
           params:  params,
           headers: {'Authorization'  => @user.authentication_token,
                     'Accept-Version' => 'v1'}
      cr = ContactRelation.all
      cb = ContactBook.all
      expect(response.status).to eq(201)

      expect(cr.size).to eq(6)
      expect(cr.where(status: :owner).size).to eq(3)
      expect(cr.where(status: :friend).size).to eq(3)

      expect(cb.size).to eq(6)
      expect(JSON.parse(response.body)['data']).to eq({"messages" => "Success sync contact."})
    end
    it "should returns 200 with valid params when success sync phone books with 3 user pararel friend" do
      @user_2 = FactoryGirl.create(:user_2)
      @user_3 = FactoryGirl.create(:user_3, phone_number: "+6285643736789")
      params = {
        contact_book: {
          contacts: [
                      {
                        name:         @user.name,
                        email:        @user.email,
                        phone_number: @user.phone_number,
                      },
                      {
                        name:         "satu",
                        email:        "satu@pazpo.id",
                        phone_number: "+6285643736789",
                      },
                      {
                        name:         "dua",
                        email:        "dua@pazpo.id",
                        phone_number: "+6285643736456",
                      },
                      {
                        name:         "tiga",
                        email:        "tiga@pazpo.id",
                        phone_number: "+6285643736123",
                      }
                    ]
        }
      }
      post "/contact_books/",
           params:  params,
           headers: {'Authorization'  => @user.authentication_token,
                     'Accept-Version' => 'v1'}
      cr = ContactRelation.all
      cb = ContactBook.all
      expect(response.status).to eq(201)

      expect(cr.size).to eq(6)
      expect(cr.where(status: :owner).size).to eq(3)
      expect(cr.where(status: :friend).size).to eq(3)

      expect(cb.size).to eq(5)
      expect(cb.find_by(phone_number: "+6285643736789").contact_relations.size).to eq(2)

      expect(JSON.parse(response.body)['data']).to eq({"messages" => "Success sync contact."})
    end
  end
end

