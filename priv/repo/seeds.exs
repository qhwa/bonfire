# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Bonfire.Repo.insert!(%Bonfire.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Bonfire.Books.{Metadata, Book}
alias Bonfire.Repo

metadatas = [
  %Metadata{
    title: "SWITCH",
    isbn: "978-7-5086-9025-4"
  },
  %Metadata{
    title: "Structure and Interpertation of Computer Programs",
    isbn: "978-7-111-13510-4"
  }
]

Enum.each(metadatas, fn metadata ->
  md = Repo.insert!(metadata)
  Repo.insert!(%Book{metadata: md})
end)
