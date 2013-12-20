require "open-uri"
require "nokogiri"
require "yaml"
require "cgi"

module OmniFocus::Pivotaltracker
  PREFIX  = "PT"

  def load_or_create_config
    path   = File.expand_path "~/.omnifocus-pivotaltracker.yml"
    config = YAML.load(File.read(path)) rescue nil

    unless config then
      config = { :token => "TOKEN", :user_name => "Full name, initials or unique part of the user's name" }

      File.open(path, "w") { |f|
        YAML.dump(config, f)
      }

      abort "Created default config in #{path}. Go fill it out."
    end

    if config.instance_of?(Array) then
      config
    else
      [config]
    end
  end

  def populate_pivotaltracker_tasks
    config    = load_or_create_config
    config.each do |conf|
      populate_pivotaltracker_tasks_for_project(conf[:token], conf[:user_name])
    end
  end

  def populate_pivotaltracker_tasks_for_project(token, user_name)
    projects = fetch_projects(token)

    projects.each do |project|
      fetch_stories(token, project.at("id").text, user_name).each do |story|
        process_story(project, story)
      end
    end
  end

  def fetch_projects(token)
    xml = Nokogiri.parse(open("https://www.pivotaltracker.com/services/v3/projects", "X-TrackerToken" => token).read)
    xml.root.xpath("//project")
  end

  def fetch_stories(token, project_id, user_name)
    url = "https://www.pivotaltracker.com/services/v3/projects/#{project_id}/stories?filter=" +
          "mywork:#{CGI.escape(user_name)}" +
          "%20state:unscheduled,unstarted,started,rejected"

    xml = Nokogiri.parse(open(url, "X-TrackerToken" => token).read)
    xml.root.xpath("//story")
  end

  def process_story(project, story)
    number       = story.at("id").text
    url          = story.at("url").text
    project_name = project.at("name").text
    ticket_id    = "#{PREFIX}-#{project_name}##{number}"
    title        = "#{ticket_id}: #{story.at("name").text}"

    if existing[ticket_id]
      bug_db[existing[ticket_id]][ticket_id] = true
      return
    end

    bug_db[project_name][ticket_id] = [title, url]
  end
end
