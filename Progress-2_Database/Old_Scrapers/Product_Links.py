import requests
from bs4 import BeautifulSoup
import time
import csv

def scrape_mecca_products(homepage_url):
    product_details_list = []
    page_number = 1

    while True:
        current_page_url = f"{homepage_url}?page={page_number}"
        response = requests.get(current_page_url)
        if response.status_code != 200:
            print(f"Failed to retrieve page {page_number}: Status code {response.status_code}")
            break

        soup = BeautifulSoup(response.content, 'html.parser')
        product_links = soup.find_all('a', class_='css-mijcyd')
        if not product_links:
            print(f"No products found on page {page_number}. Ending scrape.")
            break

        for link in product_links:
            href = link.get('href')
            if not href:
                continue

            full_url = 'https://www.mecca.com' + href
            name = link.text.strip()

            # Extract brand from the URL
            try:
                brand = href.split('/')[2]  # /en-au/brand-name/product-name
            except IndexError:
                brand = "Unknown"

            product_details_list.append({
                'name': name,
                'brand': brand,
                'url': full_url
            })

        print(f"Page {page_number}: Found {len(product_links)} products.")
        page_number += 1
        time.sleep(1)

    return product_details_list

# MAIN
homepage_url = 'https://www.mecca.com/en-au/skincare/'
all_product_details = scrape_mecca_products(homepage_url)

# Write to CSV
csv_file_path = '/Users/lilytwelftree/Documents/Uni/MATLAB/Project/Progress-1/MATLAB_PROJECT_Mecca_Product_Details.csv'
with open(csv_file_path, 'w', newline='', encoding='utf-8') as csvfile:
    fieldnames = ['name', 'brand', 'url']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for product in all_product_details:
        writer.writerow(product)

print(f"Scraping completed! {len(all_product_details)} products written to CSV.")
