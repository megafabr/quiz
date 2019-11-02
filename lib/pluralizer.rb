class Pluralizer
  def self.endings(number, word, word_singular, word_plural)
    if number <= 20
      small_number = number
    else
      small_number = number % 100
      if small_number > 20
        small_number = small_number % 10
      end
    end

    # единственное число
    if small_number == 1
      return word
      # для чисел 2, 3 и 4 слово в единственном числе в родительном падеже
    elsif small_number > 1 && small_number < 5
      return word_singular

      # для чисел больше 4 и меньше 21 слово во множественном числе, родительном падеже
    end
    word_plural
  end
end
