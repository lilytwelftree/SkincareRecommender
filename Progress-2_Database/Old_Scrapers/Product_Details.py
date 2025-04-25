import requests
from bs4 import BeautifulSoup
import re
import time
import csv

def extract_product_details(product_link):
    for attempt in range(3):
        try:
            response = requests.get(product_link, timeout=15)
            response.raise_for_status()
            soup = BeautifulSoup(response.text, 'html.parser')

            # Brand
            brand = soup.select_one('[data-testid="product-brand"]')
            brand_name = brand.get_text(strip=True) if brand else "N/A"

            # Product Name
            product_name = soup.select_one('[data-testid="product-name"]')
            product_name_text = product_name.get_text(strip=True) if product_name else "N/A"

            # Price
            price = soup.select_one('[data-testid="product-price"]')
            price_text = price.get_text(strip=True) if price else "N/A"

            # Breadcrumbs for category and subcategory
            breadcrumbs = soup.select('.css-1p9umtw')
            if len(breadcrumbs) >= 4:
                category = breadcrumbs[2].get_text(strip=True)
                subcategory = breadcrumbs[3].get_text(strip=True)
            elif len(breadcrumbs) == 3:
                category = breadcrumbs[2].get_text(strip=True)
                subcategory = "N/A"
            else:
                category = subcategory = "N/A"

            # Stock status
            stock_status = soup.select_one('.css-lv0o5n')
            stock_text = "Out of Stock" if stock_status and "Out of Stock Online" in stock_status.get_text() else "In Stock"

            # Weight
            weight_g, weight_ml = extract_weight(soup, product_name_text)

            # Review count
            review_link = soup.select_one('a[href="#rating-overview"]')
            review_count = re.search(r'(\d+)', review_link.get_text(strip=True)) if review_link else None
            review_number = review_count.group(1) if review_count else "N/A"

            # Rating
            rating = soup.select_one('.css-1r68oyn')
            rating_text = rating.get_text(strip=True) if rating else "N/A"

            # Benefits
            benefits_section = soup.select_one('h3:contains("Benefits")')
            benefits = "N/A"
            if benefits_section:
                ul = benefits_section.find_next_sibling("ul")
                if ul:
                    benefits = ', '.join(li.get_text(strip=True).replace('•', '').strip() for li in ul.select('li'))

            # Key Ingredients
            key_ingredients = extract_section_text(soup, "Key ingredients")

            # Made Without
            made_without = extract_section_text(soup, "Made without")

            # Usage
            usage = extract_section_text(soup, "Usage")

            # Full ingredients
            ingredients_block = soup.select_one('[title="Ingredients"]')
            ingredients = ingredients_block.get_text(strip=True) if ingredients_block else "N/A"

            return {
                'brand': brand_name,
                'product_name': product_name_text,
                'price': price_text,
                'category': category,
                'subcategory': subcategory,
                'weight_g': weight_g,
                'weight_ml': weight_ml,
                'stock_status': stock_text,
                'review_count': review_number,
                'rating': rating_text,
                'benefits': benefits,
                'key_ingredients': key_ingredients,
                'made_without': made_without,
                'usage': usage,
                'ingredients': ingredients,
                'link': product_link
            }

        except requests.exceptions.RequestException as e:
            print(f"Attempt {attempt + 1} failed for {product_link}: {e}")
            if attempt == 2:
                return None
            time.sleep(2)

def extract_weight(soup, product_name):
    weight_g = 0
    weight_ml = 0

    def process_weight_match(matches):
        nonlocal weight_g, weight_ml
        for multiplier, value, unit in matches:
            value = int(value)
            if multiplier:
                value *= int(multiplier)
            if unit.lower() == 'g':
                weight_g += value
            elif unit.lower() == 'ml':
                weight_ml += value

    name_matches = re.findall(r'(\d*)\s*x?\s*(\d+)(g|ml)', product_name, re.IGNORECASE)
    process_weight_match(name_matches)

    if weight_g == 0 and weight_ml == 0:
        description = soup.select('.css-ft3nhk')
        for paragraph in description:
            matches = re.findall(r'(\d*)\s*x?\s*(\d+)(g|ml)', paragraph.get_text(strip=True), re.IGNORECASE)
            process_weight_match(matches)

    return weight_g if weight_g > 0 else "N/A", weight_ml if weight_ml > 0 else "N/A"

def extract_section_text(soup, header_text):
    section = soup.find('h3', string=re.compile(header_text, re.IGNORECASE))
    if section:
        paragraphs = section.find_parent().find_all('p')
        return ' '.join(p.get_text(strip=True) for p in paragraphs if p.get_text(strip=True)).strip()
    return "N/A"

import csv

def main(start_index=0):
    input_path = '/Users/lilytwelftree/Documents/Uni/MATLAB/Project/Progress-1/Product_CSV/Product_Links.csv'
    output_path = '/Users/lilytwelftree/Documents/Uni/MATLAB/Project/Progress-1/Details.csv'

    with open(input_path, 'r') as file:
        # Read the file and check the headers
        reader = csv.DictReader(file)
        headers = reader.fieldnames
        print(f"Headers: {headers}")

        # Clean up the headers if there are typos (e.g., "ame" should be "name")
        headers = [header.strip().lower() for header in headers]
        if 'ame' in headers:
            headers[headers.index('ame')] = 'name'
        print(f"Fixed headers: {headers}")

        # Read the CSV again with corrected headers
        file.seek(0)
        reader = csv.DictReader(file, fieldnames=headers)

        # Extract URLs
        product_links = [row['url'] for row in reader if 'url' in row]
        print(f"Found {len(product_links)} product links.")

    with open(output_path, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow([
            'Product Number', 'Brand', 'Product Name', 'Price', 'Category', 'Subcategory',
            'Weight (g)', 'Weight (ml)', 'Stock Status', 'Review Count', 'Rating',
            'Benefits', 'Key Ingredients', 'Made Without', 'Usage', 'Ingredients', 'Link'
        ])

        for index in range(start_index, len(product_links)):
            product_link = product_links[index]
            details = extract_product_details(product_link)
            if details:
                writer.writerow([
                    index + 1,
                    details['brand'],
                    details['product_name'],
                    details['price'],
                    details['category'],
                    details['subcategory'],
                    details['weight_g'],
                    details['weight_ml'],
                    details['stock_status'],
                    details['review_count'],
                    details['rating'],
                    details['benefits'],
                    details['key_ingredients'],
                    details['made_without'],
                    details['usage'],
                    details['ingredients'],
                    details['link']
                ])
                print(f"Processed product {index + 1}: {details['product_name']}")

    print(f"✅ CSV file '{output_path}' has been created successfully.")

if __name__ == "__main__":
    main(start_index=0)
