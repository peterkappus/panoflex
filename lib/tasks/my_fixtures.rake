namespace :db do
  desc "Load my custom fixtures to popluate the database. Not quite Factory Girl..."
  namespace :my_fixtures do

    task groups_and_teams: [:environment, :warn] do
      #have to delete goals before deleting teams...
      Goal.destroy_all
      Group.destroy_all
      Team.destroy_all

      digital = Group.create!(name: "Digital")
      Group.create!(name: "Technology")
      digital.teams << Team.create!(name: "GaaP")
      digital.teams << Team.create!(name: "GOV.UK")
    end

    task goals: [:environment, :groups_and_teams] do
      require 'Date'
      make_sub_goals(nil,0)

    end

    def new_goal(parent)
      verb = %w/build grow save develop write engage test release find/.sample
      noun = %w/users departments platforms tools savings/.sample
      month = %w/January March April July September December/.sample
      year = %w/2016 2017 2018/.sample
      Goal.create!(name: "#{verb.humanize} #{[*(1..500)].sample} #{noun} by #{month.humanize} #{year}.", start_date: Date.today, deadline: Date.parse("#{month} #{year}"), owner: User.all.sample, group: Group.first, team: Group.first.teams.sample, parent: parent)
    end

    #recursive function to make 5 child goals at each level
    def make_sub_goals (parent, depth)
      #make up to 4 sub goals
      [*(2..10)].sample.times do
        g = new_goal(parent)

        #max depth...
        if(depth < 2)
          puts " #{depth} id: #{g.id} name: #{g.name} parent: #{parent.name if parent.present?}"
          make_sub_goals(g,depth+1)
        end
      end
    end

    task warn: [:environment] do
      #puts "WARNING: This may erase/overwrite existing data. Press enter to continue."
      #STDIN.gets
    end

    task users: [:environment, :warn] do
      #remove only the test accounts we've created.
      #this leaves any accounts we've created by logging in manually
      User.where("email like ?","%test.com%").destroy_all

      #admin user
      User.create!(name: 'Suzy Admin', admin: true, email: "email0@test.com")

      #some other users
      [*(1..10)].each do |i|
        User.create!(name: %w{Cindy Ada Jane Barbara Ann Benjamin Walter Alexis Simone Marina Oscar Julia Mark Lazlo Ray Lucretia Tom Peter Sarah Ringo John}.sample + " " + %w{Smith Jones Taylor Gibran Peterson Williams Mott Eames Johnson Davies Robinson Wright Knight Thompson Evans Walker White Roberts Green Hall Wood Jackson Clarke}.sample + " " + i.to_s, email: "email#{i}@test.com")
      end
    end

    task :all => [:warn, :users, :groups_and_teams, :goals]

  end
end
