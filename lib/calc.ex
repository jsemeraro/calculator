defmodule Calc do
  require IEx
  alias Tree

  def eval(equ) do
    # list of parsed equation
    parsed_list = equ |> String.split(["\n", " "]) |> parse_equ

    # validate the first element
    first_elem = List.first(parsed_list)
    if determine_num?(first_elem) or first_elem == "(" do
      tree = build_tree(parsed_list)
      IO.puts("tree: " <> inspect tree)
      IO.puts(solving(tree))
    else
      IO.puts("Error: invalid input")
    end
  end

  def solving(tree) do
    if is_number(tree) do
      tree
    else
      op = tree.op
      left = tree.left
      right = tree.right
      case op do
        :+ ->
          solving(left) + solving(right)
        :- ->
          solving(left) - solving(right)
        :* ->
          solving(left) * solving(right)
        :/ ->
          solving(left) / solving(right)
      end
    end
  end
  
  def parse_equ(equ_list) do
    if "" in equ_list do
      list = List.delete(equ_list, "")
      parse_equ(list)
    else
      equ_list
    end
  end

  def determine_num?(elem) do
    Regex.match?(~r/\d+/, elem)
  end

  def determine_open(elem) do
    elem == "("
  end

  def find_close(list, ct, pos) do
    [first | tail] = list
    
    if Enum.any?(list, fn(x) -> x == ")" end) do
      case first do 
        ")" ->
          if ct == 1 do
            pos
          else 
            find_close(tail, ct-1, pos+1)
          end
        "(" ->
          find_close(tail, ct+1, pos+1)
        _ ->
          find_close(tail, ct, pos+1)
      end
    else
      IO.puts("find_close first " <> inspect first)
      IO.puts("find_close tail " <> inspect tail)
      IO.puts("Error: invalid parens")
      nil
    end
  end

  def trim_parens(list) do
    first = List.first(list)
    last = List.last(list)
    if determine_open(first) && last == ")" do 
      trim_parens(Enum.slice(list, 1..-2))
    else
      list
    end
  end

  def parse_ops(str) do
    case str do
      "+" -> :+
      "-" -> :-
      "*" -> :*
      "/" -> :/
    end
  end


  def build_tree(equ_list) do
    if !is_nil(equ_list) && !Enum.empty?(equ_list) do
      IO.puts("FIRST of equ_list " <> inspect equ_list)
      equ_list = trim_parens(equ_list)
      IO.puts("trimmed list " <> inspect equ_list)
      [first | tail] = equ_list
      
      cond do
        determine_open(first) ->
          # find position of closing paren
          close = find_close(tail, 1, 0)
          IO.puts("build_tree DO close pos " <> inspect close)
          
          # this is the tail which should be everything but the first paren
          IO.puts("build_tree DO tail: " <> inspect tail)
          
          # grabs everything in the parens and evaluates to the left
          left = Enum.slice(tail, 0..close-1)
          IO.puts("build_tree DO left " <> inspect left)
          
          # should grab the second operand
          right_list = Enum.slice(tail, close+1..-1)

          op = find_op(right_list)
          IO.puts("op " <> inspect Enum.at(right_list, op))
          
          # grabs the rest of the equation and throws it in the right
          right = Enum.slice(right_list, op+1..-1)
          IO.puts("build_tree DO right " <> inspect right)
          
          %Tree{op: Enum.at(right_list, op) |> parse_ops, left: build_tree(left), right: build_tree(right)}


        !is_nil(find_op(equ_list)) ->
          left = Enum.slice(equ_list, 0..find_op(equ_list)-1)
          IO.puts("NIL left " <> inspect left)
          right = Enum.slice(equ_list, find_op(equ_list)+1..-1)
          IO.puts("NIL right " <> inspect right)
          %Tree{op: Enum.at(equ_list, find_op(equ_list)) |> parse_ops, left: build_tree(left), right: build_tree(right)}

        determine_num?(first) ->
          String.to_integer(first)
      end
    else
      nil
    end
  end

  def find_op(equ_list) do
    Enum.find_index(equ_list, fn(x) -> Regex.match?(~r/(\+|\-|\*|\/)/, x) end)
  end

  def main() do
    # found gets here: https://hexdocs.pm/elixir/IO.html#gets/2
    IO.gets("Enter a math equation: ") |> eval
    main()
  end
end