class Board

  attr_reader :symbol

  def initialize
    @board = (1..9).to_a
    @winning_moves = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                      [0, 3, 6], [1, 4, 7], [2, 5, 8],
                      [0, 4, 8], [2, 4, 6]]
  end

  def change_symbol
    @symbol == "X" ? @symbol = "O" : @symbol = "X"
  end

  def show_board
    print "\n"
    (0..6).step(3) { |i| make_board(i) }
  end

  private
  def make_board(i)
    print row(i).join(" | "), row_divider(i)
  end

  def row(i)
    @board[i..i + 2]
  end

  def row_divider(i)
    i == 6 ? "\n\n" : "\n--+---+--\n"
  end

  public

  def check_move?(move)
    @board.include?(move)
  end

  def store_move(move)
    @board[@board.index(move)] = @symbol
  end

  def game_won?
    @winning_moves.any? { |line| win_check?(line) }
  end

  def win_check?(line)
    line.all? { |value| @board[value] == @symbol }
  end

  def no_moves_left?
    @board.all? { |position| position.is_a? String }
  end

end

class Player
  attr_reader :game_over

  def initialize(player_1, player_2)
    @player_1 = player_1
    @player_2 = player_2
    @player = @player_1
    
    @board = Board.new
    @game_over = false
  end

  def turn
    @board.show_board
    @board.change_symbol
    @player = @player == @player_1 ? @player_2 : @player_1
    player_move
    player_won
    board_full
  end

  private

  def player_move
    print "#{@player}(#{@board.symbol}), make your move: "
    move = gets.to_i
    @board.check_move?(move) ? @board.store_move(move) : player_move
  end

  def board_full
    if @board.no_moves_left?
      @game_over = true
      print "\nGAME OVER: Draw!\n"
      @board.show_board
    end
  end

  def player_won
    if @board.game_won?
      @game_over = true
      puts "\nGAME OVER: #{@player}(#{@board.symbol}) won!\n"
      @board.show_board
    end
  end

end

class PlayerValidation
  def self.get_players
    begin
      print "First player, put your name then press ENTER: "
      name_1 = gets.chomp
      print "Second player, put your name then press ENTER: "
      name_2 = gets.chomp

      raise "Put the different name for players!" if name_1 == name_2
      
      [name_1, name_2]
    rescue => e
      puts e.message
      retry
    end
  end
end

class Game

  puts "Hello, this is TIC-TAC-TOE game for two players."

  def initialize(player_1, player_2)
    @player = Player.new(player_1, player_2)
    start_game
  end

  private
  
  def start_game
    take_turn until @player.game_over
  end

  def take_turn
    @player.turn
  end

end

player_1, player_2 = PlayerValidation.get_players
game = Game.new(player_1, player_2)
