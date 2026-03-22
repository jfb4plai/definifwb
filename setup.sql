-- DéfiniFWB — Script SQL à exécuter dans Supabase > SQL Editor
-- Compatible avec le même projet Supabase que FlashFWB (tables séparées préfixées "def_")

-- ============================================================
-- TABLE : séances de définitions
-- ============================================================
create table if not exists public.def_sessions (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid references auth.users on delete cascade not null,
  titre         text not null,
  date          date not null default current_date,
  mode_actif    text not null default 'cliquable',
  public_access boolean not null default false,
  created_at    timestamptz not null default now()
);

-- ============================================================
-- TABLE : mots et définitions
-- ============================================================
create table if not exists public.def_mots (
  id         uuid primary key default gen_random_uuid(),
  session_id uuid references public.def_sessions on delete cascade not null,
  mot        text not null,
  definition text not null,
  image_url  text,
  ordre      integer not null default 0
);

-- ============================================================
-- TABLE : consultations élèves (analytics)
-- ============================================================
create table if not exists public.def_consultations (
  id           uuid primary key default gen_random_uuid(),
  mot_id       uuid references public.def_mots on delete cascade not null,
  session_id   uuid references public.def_sessions not null,
  consulted_at timestamptz not null default now()
);

-- ============================================================
-- RLS : def_sessions
-- ============================================================
alter table public.def_sessions enable row level security;

-- Enseignant : accès complet à ses propres séances
create policy "def_sessions: enseignant" on public.def_sessions
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Public : lecture des séances activées (pour les élèves sur TBI)
create policy "def_sessions: lecture publique si activée" on public.def_sessions
  for select
  using (public_access = true);

-- ============================================================
-- RLS : def_mots
-- ============================================================
alter table public.def_mots enable row level security;

-- Enseignant : accès complet à ses mots (via sa séance)
create policy "def_mots: enseignant" on public.def_mots
  for all
  using (
    exists (
      select 1 from public.def_sessions s
      where s.id = def_mots.session_id
        and s.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.def_sessions s
      where s.id = def_mots.session_id
        and s.user_id = auth.uid()
    )
  );

-- Public : lecture des mots des séances activées
create policy "def_mots: lecture publique si séance activée" on public.def_mots
  for select
  using (
    exists (
      select 1 from public.def_sessions s
      where s.id = def_mots.session_id
        and s.public_access = true
    )
  );

-- ============================================================
-- RLS : def_consultations
-- ============================================================
alter table public.def_consultations enable row level security;

-- Public : les élèves peuvent enregistrer des consultations (sans compte)
create policy "def_consultations: insertion publique" on public.def_consultations
  for insert
  with check (true);

-- Enseignant : lecture de ses propres statistiques
create policy "def_consultations: lecture enseignant" on public.def_consultations
  for select
  using (
    exists (
      select 1 from public.def_sessions s
      where s.id = def_consultations.session_id
        and s.user_id = auth.uid()
    )
  );

-- ============================================================
-- INDEX (performances)
-- ============================================================
create index if not exists idx_def_sessions_user   on public.def_sessions(user_id);
create index if not exists idx_def_sessions_access on public.def_sessions(public_access);
create index if not exists idx_def_mots_session    on public.def_mots(session_id);
create index if not exists idx_def_cons_session    on public.def_consultations(session_id);
create index if not exists idx_def_cons_mot        on public.def_consultations(mot_id);
