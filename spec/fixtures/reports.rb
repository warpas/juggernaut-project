module ReportFixture
  def self.summary
    {
      "total_grand" => 66293071,
      "data" => [
        {
          "title" => {
            "project" => "Abnegation - Games",
            "client" => "Client 1"
          },
          "time" => 8993162,
          "items" => [
            {
              "title" => {
                "time_entry" => "Mobile timer"
              },
              "time" => 8993162
            }
          ]
        },
        {
          "title" => {
            "project" => "Abnegation - Hygiene",
            "client" => "Client 1"
          },
          "time" => 686000,
          "items" => [
            {
              "title" => {
                "time_entry" => "Hygiene"
              },
              "time" => 686000
            }
          ]
        },
        {
          "title" => {
            "project" => "Commute",
            "client" => "Client 1"
          },
          "time" => 14994909,
          "items" => [
            {
              "title" => {
                "time_entry" => "Travel 1"
              },
              "time" => 11943909
            },
            {
              "title" => {
                "time_entry" => "Travel 2"
              },
              "time" => 3051000
            }
          ]
        },
        {
          "title" => {
            "project" => "Dev - Juggernaut",
            "client" => "Company 2"
          },
          "time" => 178000,
          "items" => [
            {
              "title" => {
                "time_entry" => "Development time"
              },
              "time" => 178000
            }
          ]
        },
        {
          "title" => {
            "project" => "Growth - Exercise",
            "client" => "Client 1"
          },
          "time" => 65000,
          "items" => [
            {
              "title" => {
                "time_entry" => "Trening"
              },
              "time" => 65000
            }
          ]
        },
        {
          "title" => {
            "project" => "Growth - Reading",
            "client" => "Client 1"
          },
          "time" => 8783000,
          "items" => [
            {
              "title" => {
                "time_entry" => "Non-Fiction"
              },
              "time" => 8783000
            }
          ]
        },
        {
          "title" => {
            "project" => "Sleeping",
            "client" => "Client 1"
          },
          "time" => 32593000,
          "items" => [
            {
              "title" => {
                "time_entry" => "Sleeping"
              },
              "time" => 32593000
            }
          ]
        }
      ]
    }
  end

  def self.detailed
    {
      "total_grand" => 66293071,
      "total_count" => 13,
      "data"=> [
        {
          "description"=>"Hygiene",
          "start"=>"2020-07-20T21:37:47+02:00",
          "end"=>"2020-07-20T21:49:13+02:00",
          "updated"=>"2020-07-20T21:49:13+02:00",
          "dur"=>686000,
          "client"=>"Client 1",
          "project"=>"Abnegation - Hygiene",
          "tags"=>["chore"]
        },
        {
          "description"=>"Mobile timer",
          "start"=>"2020-07-20T21:02:44+02:00",
          "end"=>"2020-07-20T21:35:49+02:00",
          "updated"=>"2020-07-20T21:35:49+02:00",
          "dur"=>1985000,
          "client"=>"Client 1",
          "project"=>"Abnegation - Games",
          "tags"=>["game"]
        },
        {
          "description"=>"Travel 2",
          "start"=>"2020-07-20T20:11:35+02:00",
          "end"=>"2020-07-20T21:02:26+02:00",
          "updated"=>"2020-07-20T21:02:26+02:00",
          "dur"=>3051000,
          "client"=>"Client 1",
          "project"=>"Commute",
          "tags"=>["other"]
        },
        {
          "description"=>"Mobile timer",
          "start"=>"2020-07-20T16:57:06+02:00",
          "end"=>"2020-07-20T17:06:41+02:00",
          "updated"=>"2020-07-20T17:06:42+02:00",
          "dur"=>575000,
          "client"=>"Client 1",
          "project"=>"Abnegation - Games",
          "tags"=>["game"]
        },
        {
          "description"=>"Non-Fiction",
          "start"=>"2020-07-20T15:06:48+02:00",
          "end"=>"2020-07-20T16:55:32+02:00",
          "updated"=>"2020-07-20T16:55:34+02:00",
          "dur"=>6524000,
          "client"=>"Client 1",
          "project"=>"Growth - Reading",
          "tags"=>["work"]
        },
        {
          "description"=>"Non-Fiction",
          "start"=>"2020-07-20T14:19:28+02:00",
          "end"=>"2020-07-20T14:57:07+02:00",
          "updated"=>"2020-07-20T16:55:33+02:00",
          "dur"=>2259000,
          "client"=>"Client 1",
          "project"=>"Growth - Reading",
          "tags"=>["work"]
        },
        {
          "description"=>"Mobile timer",
          "start"=>"2020-07-20T13:09:30+02:00",
          "end"=>"2020-07-20T14:19:23+02:00",
          "updated"=>"2020-07-20T14:19:23+02:00",
          "dur"=>4193000,
          "client"=>"Client 1",
          "project"=>"Abnegation - Games",
          "tags"=>["game"]
        },
        {
          "description"=>"Travel 1",
          "start"=>"2020-07-20T09:50:27+02:00",
          "end"=>"2020-07-20T13:09:30+02:00",
          "updated"=>"2020-07-20T13:09:30+02:00",
          "dur"=>11943909,
          "client"=>"Client 1",
          "project"=>"Commute",
          "tags"=>["other"]
        },
        {
          "description"=>"Development time",
          "start"=>"2020-07-20T09:24:02+02:00",
          "end"=>"2020-07-20T09:27:00+02:00",
          "updated"=>"2020-07-20T09:25:53+02:00",
          "dur"=>178000,
          "client"=>"Company 2",
          "project"=>"Dev - Juggernaut",
          "tags"=>["work"]
        },
        {
          "description"=>"Trening",
          "start"=>"2020-07-20T09:06:38+02:00",
          "end"=>"2020-07-20T09:07:43+02:00",
          "updated"=>"2020-07-20T09:07:43+02:00",
          "dur"=>65000,
          "client"=>"Client 1",
          "project"=>"Growth - Exercise",
          "tags"=>["exercise"]
        },
        {
          "description"=>"Mobile timer",
          "start"=>"2020-07-20T08:29:20+02:00",
          "end"=>"2020-07-20T09:06:34+02:00",
          "updated"=>"2020-07-20T09:06:34+02:00",
          "dur"=>2234000,
          "client"=>"Client 1",
          "project"=>"Abnegation - Games",
          "tags"=>["game"]
        },
        {
          "description"=>"Mobile timer",
          "start"=>"2020-07-20T08:29:15+02:00",
          "end"=>"2020-07-20T08:29:21+02:00",
          "updated"=>"2020-07-20T08:29:21+02:00",
          "dur"=>6162,
          "client"=>"Client 1",
          "project"=>"Abnegation - Games",
          "tags"=>["game"]
        },
        {
          "description"=>"Sleeping",
          "start"=>"2020-07-20T00:20:47+02:00",
          "end"=>"2020-07-20T09:24:00+02:00",
          "updated"=>"2020-07-20T09:22:54+02:00",
          "dur"=>32593000,
          "client"=>"Client 1",
          "project"=>"Sleeping",
          "tags"=>["sleep"]
        }
      ]
    }
  end
end
