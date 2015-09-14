defmodule Yatzy.Score do
  @doc ~S"""
  upper(n, ds) should return the score for the roll ds used in the slot for n number
  of eyes in the upper section of the score sheet.

  ## Examples
     iex> Yatzy.Score.upper(1, [2,3,1,2,1])
     2
     iex> Yatzy.Score.upper(2, [2,2,2,3,2])
     8
  """
  def upper(n, ds) do
    ds
    |> Enum.filter(&(&1 == n))
    |> Enum.sum
  end

  @doc ~S"""
  chance(ds) should return the sum of the eyes on the dice.

  ## Examples
     iex> Yatzy.Score.chance([3,4,2,4,1])
     14
  """
  def chance(ds),
    do: Enum.sum ds

  @doc ~S"""
  yatzy(ds) should return 50 if all dice are showing the same number of eyes.

  ## Examples
     iex> Yatzy.Score.yatzy([2,3,3,3,3])
     0
     iex> Yatzy.Score.yatzy([4,4,4,4,4])
     50
  """
  def yatzy([x, x, x, x, x]),
    do: 50
  def yatzy(_),
    do: 0

  @doc ~S"""
  small_straight(ds) should return 15 for any set of dice containing the
  sequence 1-2-3-4-5 in any order.

  ## Examples
     iex> Yatzy.Score.small_straight([1,2,3,4,6])
     0
     iex> Yatzy.Score.small_straight([2,4,3,1,5])
     15
  """
  def small_straight(ds) do
    ds
    |> Enum.sort
    |> do_small_straight
  end

  defp do_small_straight([1, 2, 3, 4, 5]),
    do: 15
  defp do_small_straight(_),
    do: 0

  @doc ~S"""
  large_straight(ds) should return 20 for any set of dice containing the
  sequence 2-3-4-5-6 in any order.

  ## Examples
     iex> Yatzy.Score.large_straight([5,2,3,2,6])
     0
     iex> Yatzy.Score.large_straight([6,2,4,3,5])
     20
  """
  def large_straight(ds) do
    ds
    |> Enum.sort
    |> do_large_straight
  end

  defp do_large_straight([2, 3, 4, 5, 6]),
    do: 20
  defp do_large_straight(_),
    do: 0

  @doc ~S"""
  four_of_a_kind(ds) has a value when there are four of a kind in the roll and then
  its value is the total number of eyes on the dice being four of a kind.

  ## Examples
     iex> Yatzy.Score.four_of_a_kind([2,3,3,3,5])
     0
     iex> Yatzy.Score.four_of_a_kind([5,5,5,2,5])
     20
  """
  def four_of_a_kind(ds) do
    ds
    |> sort_by_occurances
    |> do_four_of_a_kind
  end

  defp do_four_of_a_kind([x, x, x, x, _]),
    do: x * 4
  defp do_four_of_a_kind(_),
    do: 0

  @doc ~S"""
  three_of_a_kind(ds) has a value when there are three of a kind in the roll and then
  its value is the total number of eyes on the dice being three of a kind.

  ## Examples
     iex> Yatzy.Score.three_of_a_kind([2,3,4,3,5])
     0
     iex> Yatzy.Score.three_of_a_kind([4,1,4,2,4])
     12
  """
  def three_of_a_kind(ds) do
    ds
    |> sort_by_occurances
    |> do_three_of_a_kind
  end

  defp do_three_of_a_kind([x, x, x, _, _]),
    do: x * 3
  defp do_three_of_a_kind(_),
    do: 0

  @doc ~S"""
  one_pair(ds) has a value when there is a pair in the roll and then
  its value is the total number of eyes on the dice in the pair.

  ## Examples
     iex> Yatzy.Score.one_pair([2,3,4,1,5])
     0
     iex> Yatzy.Score.one_pair([4,6,6,2,5])
     12
  """
  def one_pair(ds) do
    ds
    |> sort_by_occurances
    |> do_one_pair
  end

  defp do_one_pair([x, x, _, _, _]),
    do: x * 2
  defp do_one_pair(_),
    do: 0

  @doc ~S"""
  two_pairs(ds) has a value when there is two pairs in the roll and then
  its value is the total number of eyes on the dice in the two pairs.

  ## Examples
     iex> Yatzy.Score.two_pairs([2,3,3,3,3])
     0
     iex> Yatzy.Score.two_pairs([2,4,6,2,6])
     16
  """
  def two_pairs(ds) do
    ds
    |> sort_by_occurances
    |> do_two_pairs
  end

  defp do_two_pairs([x, x, x, y, y]) when x != y,
    do: x * 2 + y * 2
  defp do_two_pairs([x, x, y, y, _]) when x != y,
    do: x * 2 + y * 2
  defp do_two_pairs(_),
    do: 0

  @doc ~S"""
  full_house(ds) has a value when there is three of a kind and a pair in the roll.
  The value is the sum of the eyes on the dice.

  ## Examples
     iex> Yatzy.Score.full_house([3,3,3,3,3])
     0
     iex> Yatzy.Score.full_house([3,3,6,3,6])
     21
  """
  def full_house(ds) do
    ds
    |> sort_by_occurances
    |> do_full_house
  end

  defp do_full_house([x, x, x, y, y]) when x != y,
    do: x * 3 + y * 2
  defp do_full_house(_),
    do: 0

  # helpers
  defp sort_by_occurances(ds) do
    ds
    |> Enum.group_by(&(&1))
    |> Map.values
    |> Enum.sort_by(&length/1, &>=/2)
    |> List.flatten
  end
end
