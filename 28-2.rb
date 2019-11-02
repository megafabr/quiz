# encoding: utf-8

# XXX/ Этот код необходим только при использовании русских букв на Windows
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end
# /XXX
NUMBER_OF_QUESTIONS = 3
require_relative 'lib/quiz'
require_relative 'lib/evaluation_of_response'
require_relative 'lib/pluralizer'

# ---

puts "Мини-викторина. Проверим правило возведения в квадрат чисел, оканчивающихся на 5"

# сколько будет вопросов + начальные суммы для правильных ответов и количества баллов
right_answers = 0
score = 0
quiz = Quiz.new(NUMBER_OF_QUESTIONS)

# задаем очередной вопрос
# и согласуем слово "балл" с количеством
quiz.questions.each do |item|
  puts quiz.ask_question(item)

  # даем ограниченное время чтобы ответить на вопрос
  start_thinking = Time.now
  user_answer = gets.to_i
  end_thinking = Time.now
  delta = (end_thinking - start_thinking)

  # сообщаем при правильном, не правильном и слишком долгом ответе
  right_wrong_to_late_answer = quiz.right_wrong_to_late_answer(item, user_answer, delta)
  puts right_wrong_to_late_answer.verdict
  puts

  # подсчитываем количество правильных ответов и набранных баллов
  right_answers += right_wrong_to_late_answer.yes
  score += right_wrong_to_late_answer.sum
end

# сообщаем количество правильных ответов
puts "Правильных ответов:  #{right_answers} из #{NUMBER_OF_QUESTIONS}"
puts "Вы набрали #{score} #{Pluralizer.endings(score, "балл", "балла", "баллов")}"


