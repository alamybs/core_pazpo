class API::Mobile::V1::HelloWorlds::Resources::HelloWorlds < Grape::API
  include API::Mobile::V1::Config
  resource "development" do
    desc "Version"
    params do
      requires :player_id, type: String
    end
    get "notification" do
      response = []
      # notif to user target
      n  = Notifier.new({message: "Alam YBS baru saja mengikuti kamu. Ikuti kembali!", data: {
        user: {
          id:   "dummy-2312312-321312-312312",
          name: "Alam YBS",
          picture: User.last.picture,
        }
      }, recipient:               [params.player_id], event: "follower_info"})
      os = OneSignal.new({notifier: n})
      os.push
      response << os.response

      # notif friend in contact
      n  = Notifier.new({message: "Teman anda Alam YBS baru saja bergabung di PAZPO", data: {
        user: {
          id:      "dummy-2312312-321312-312312",
          name:    "Alam YBS",
          picture: User.last.picture,
        }
      }, recipient:               [params.player_id], event: "friend_join"})
      os = OneSignal.new({notifier: n})
      os.push
      present response
    end
  end
end
