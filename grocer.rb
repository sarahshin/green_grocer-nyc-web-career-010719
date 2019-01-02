def consolidate_cart(cart)
  count_cart = {}
  cart.each do |item_hash|
    item_hash.each do |item, hash|
      if count_cart[item].nil?
        count_cart[item] = hash.merge(:count => 1)
      else
        count_cart[item][:count] += 1
      end
    end
  end
  count_cart
end

def apply_coupons(cart, coupons)
  hash = cart
  coupons.each do |coupon_hash|
    item = coupon_hash[:item]
    if !hash[item].nil? && hash[item][:count] >= coupon_hash[:num]
      temp = {"#{item} W/COUPON" => {
        :price => coupon_hash[:cost],
        :clearance => hash[item][:clearance],
        :count => 1
        }
      }
      if hash["#{item} W/COUPON"].nil?
        hash.merge!(temp)
      else
        hash["#{item} W/COUPON"][:count] += 1
      end
      hash[item][:count] -= coupon_hash[:num]
    end
  end
  hash
end

def apply_clearance(cart)
  cart.each do |item, hash|
    if hash[:clearance] == true
      hash[:price] = (hash[:price]*0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  og_cart = consolidate_cart(cart)
  cart1 = apply_coupons(og_cart, coupons)
  cart2 = apply_clearance(cart1)

  total = 0

  cart2.each do |name, price_hash|
    total += price_hash[:price] * price_hash[:count]
  end

  if total > 100
    total * 0.9
  else
    total
  end

end
