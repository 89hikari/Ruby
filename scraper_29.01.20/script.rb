require 'byebug'
require 'httparty'
require 'nokogiri'

def script

    f = File.open 'data.txt', 'w'

    url = "http://blockwork.ai/"
    unparsed_page = HTTParty.get(url)
    parsed = Nokogiri::HTML(unparsed_page)
    job_list = parsed.css('div.listingCard')    # 50 jobs!
    all_jobs = Array.new

    page = 1
    per_page = job_list.count
    total = parsed.css('div.job-count').text.split(' ')[1].gsub(',','').to_i
    last_page = (total.to_f / per_page.to_f).round
    job_count = 0
    while page <= last_page
        pagination = "http://blockwork.ai/listings?page=#{page}"
        pagination_unparsed_page = HTTParty.get(pagination)
        pagination_parsed = Nokogiri::HTML(pagination_unparsed_page)
        pagination_job_list = pagination_parsed.css('div.listingCard')

        f.write "Page #{page})\n"

        pagination_job_list.each do |jobs|
            job_count += 1
            f.write "Job #{job_count}) "
            job = {
                title: jobs.css('span.job-title').text,
                company: jobs.css('span.company').text,
                location: jobs.css('span.location').text,
                url: "http://blockwork.ai" + jobs.css('a')[0].attributes["href"].text
            }
            all_jobs << job
            f.write "Title: #{job[:title].gsub(/\s+/, " ").strip}, Company: #{job[:company].gsub(/\s+/, " ").strip}, Location: #{job[:location].gsub(/\s+/, " ").strip}, Url: #{job[:url].gsub(/\s+/, " ").strip}\n"
            f.write "\n"
        end
        page += 1
    end 
end

script