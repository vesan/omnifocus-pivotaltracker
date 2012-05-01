require "open-uri"
require "nokogiri"

module OmniFocus::Pivotaltracker
  PREFIX  = "PT"

  def load_or_create_config
    path   = File.expand_path "~/.omnifocus-pivotaltracker.yml"
    config = YAML.load(File.read(path)) rescue nil

    unless config then
      config = { :token => "TOKEN" }

      File.open(path, "w") { |f|
        YAML.dump(config, f)
      }

      abort "Created default config in #{path}. Go fill it out."
    end

    config
  end

  def populate_pivotaltracker_tasks
    config = load_or_create_config
    token  = config[:token]

    projects = fetch_projects(token)

    projects.each do |project|
      fetch_stories(token, project["id"]).each do |story|
        number = story["id"]
        url    = story["url"]
        project = project["name"]
        ticket_id = "#{PREFIX}-#{project}##{number}"
        title = "#{ticket_id}: #{story["name"]}"

        if existing[ticket_id]
          bug_db[existing[ticket_id]][ticket_id] = true
          next
        end

        bug_db[project][ticket_id] = [title, url]
      end
    end
  end

  def fetch_project_ids(token)
    xml = Nokogiri.parse(open("http://www.pivotaltracker.com/services/v3/projects", "X-TrackerToken" => token).read)
    xml.root.xpath("//project")
  end

  def fetch_stories(token, project_id)
    xml = Nokogiri.parse(open("http://www.pivotaltracker.com/services/v3/projects/#{project_id}/storie", "X-TrackerToken" => token).read)
    xml.root.xpath("//story")
  end
end
