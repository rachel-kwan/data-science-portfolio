from bs4 import BeautifulSoup # Extract data from html files
import pandas as pd # Work with data frames
from datetime import datetime, date, timedelta # Track dates
from time import sleep # Make sure page is loaded before sending requests
import requests # Send HTTP requests to get info from webpages
import html5lib
from selenium import webdriver

class ChartScraper(object):
    
    def __init__(self, market, top_n):
        self.market = market
        self.top_n = top_n
        self.dates = []
        self.url_list = []
        self.data = []
    
    def get_dates(self):
        start_date = date(2021, 1, 1)
        end_date = date.today()
        delta = end_date - start_date
        for i in range(delta.days//7):
            day_start = start_date + timedelta(weeks = i)
            day_end = day_start + timedelta(days = 7)
            week_start = day_start.strftime('%Y-%m-%d')
            week_end = day_end.strftime('%Y-%m-%d')
            self.dates.append(week_start + "--" + week_end)
        
        return self.dates
    
    def get_url_list(self):
        base_url = "https://spotifycharts.com/regional/" + self.market + "/weekly/"
        for date in self.get_dates():
            full_url = base_url + date
            self.url_list.append(full_url)
        
        return self.url_list
    
    def get_data(self):
        
        self.driver = webdriver.Chrome("/Users/rachelkwan/Downloads/chromedriver")
        
        for url in self.get_url_list():
            self.driver.get(url)
            sleep(2)
            page_source = self.driver.page_source
            soup = BeautifulSoup(page_source, "html5lib")
            songs = soup.find("table", {"class": "chart-table"})
            self.driver.get(url)

            for track in songs.find("tbody").find_all("tr")[0:(self.top_n +1)]:
                artist = track.find("td", {"class": "chart-table-track"}).find("span").text
                artist = artist.replace("by ", "").strip()
                title = track.find("td", {"class": "chart-table-track"}).find("strong").text
                streams = track.find("td", {"class": "chart-table-streams"}).text
                url_date = url.split("weekly/")[1].split("--")[1]
                chart_date = (datetime.strptime(url_date, '%Y-%m-%d') - timedelta(days = 1)).strftime('%Y-%m-%d')
                self.data.append([chart_date, title, artist, streams])
        
        return self.data
            
    def get_data_frame(self):
        final_df = pd.DataFrame(self.get_data(), columns = ["Chart Date", "Title", "Artist", "Streams"]) 
        final_df.to_csv(self.market.capitalize() + '_Top' + str(self.top_n) + '_Weekly_Jan2021_Oct2021.csv')