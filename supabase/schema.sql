create table if not exists public.contact_messages (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(btrim(name)) between 1 and 100),
  contact text not null check (char_length(btrim(contact)) between 1 and 200),
  vibe text not null check (vibe in ('Drinks or coffee', 'Grab food', 'Just see where it goes')),
  message text check (message is null or char_length(message) <= 2000),
  created_at timestamptz not null default now()
);

alter table public.contact_messages enable row level security;

revoke all on table public.contact_messages from anon, authenticated;
grant insert on table public.contact_messages to anon;

drop policy if exists "Anyone can submit a contact message" on public.contact_messages;
create policy "Anyone can submit a contact message"
  on public.contact_messages
  for insert
  to anon
  with check (
    char_length(btrim(name)) between 1 and 100
    and char_length(btrim(contact)) between 1 and 200
    and vibe in ('Drinks or coffee', 'Grab food', 'Just see where it goes')
    and (message is null or char_length(message) <= 2000)
  );
