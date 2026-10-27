-- Campus Guide database setup for Supabase (run the entire file in SQL Editor).
-- Institution rows are read-only from the public website. Add/update them using the Supabase dashboard/admin workflow.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  stream text not null check (stream in ('Science','Commerce','Arts','Other')),
  current_qualification text not null check (current_qualification in ('Class 10','Class 12','Diploma', 'Bachelor''s degree','Master''s degree','Other')),
  target_level text not null check (target_level in ('UG','PG','PhD')),
  subject text not null,
  preferred_institution_type text check (preferred_institution_type in ('central_university','iit','nit')),
  preferred_state text,
  current_institution text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
drop policy if exists "Students can read their own profile" on public.profiles;
create policy "Students can read their own profile" on public.profiles for select to authenticated using (auth.uid() = id);
drop policy if exists "Students can insert their own profile" on public.profiles;
create policy "Students can insert their own profile" on public.profiles for insert to authenticated with check (auth.uid() = id);
drop policy if exists "Students can update their own profile" on public.profiles;
create policy "Students can update their own profile" on public.profiles for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

create table if not exists public.institutions (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  institution_type text not null check (institution_type in ('central_university','iit','nit')),
  city text,
  state text,
  official_website text,
  streams text[] not null default '{}',
  levels text[] not null default '{}',
  subjects text[] not null default '{}',
  research_areas text[] not null default '{}',
  campus_environment text check (campus_environment in ('Research-focused','Peaceful','Vibrant')),
  academics_summary text,
  research_summary text,
  hostel_summary text,
  food_summary text,
  overall_score numeric(2,1) check (overall_score between 1 and 5),
  academics_score numeric(2,1) check (academics_score between 1 and 5),
  research_score numeric(2,1) check (research_score between 1 and 5),
  hostel_score numeric(2,1) check (hostel_score between 1 and 5),
  food_score numeric(2,1) check (food_score between 1 and 5),
  profile_status text not null default 'directory_only' check (profile_status in ('directory_only','review_pending','published')),
  is_active boolean not null default true,
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

alter table public.institutions enable row level security;
drop policy if exists "Public can read active institution records" on public.institutions;
create policy "Public can read active institution records" on public.institutions for select to anon, authenticated using (is_active = true);
-- Intentionally no public insert/update/delete policies: manage institutional records through an admin workflow only.

create table if not exists public.student_feedback (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  institution_name text not null,
  program text not null,
  category text not null check (category in ('Academics & faculty','Research & laboratories','Hostel & accommodation','Food & mess','Campus environment','Overall experience')),
  rating integer not null check (rating between 1 and 5),
  review text not null check (char_length(review) >= 20),
  moderation_status text not null default 'pending' check (moderation_status in ('pending','approved','rejected')),
  is_verified_student boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.student_feedback enable row level security;
drop policy if exists "Students can submit feedback for moderation" on public.student_feedback;
create policy "Students can submit feedback for moderation" on public.student_feedback for insert to authenticated with check (auth.uid() = user_id and moderation_status = 'pending' and is_verified_student = false);
drop policy if exists "Students can read their own feedback" on public.student_feedback;
create policy "Students can read their own feedback" on public.student_feedback for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Public can read approved feedback" on public.student_feedback;
create policy "Public can read approved feedback" on public.student_feedback for select to anon, authenticated using (moderation_status = 'approved');

create table if not exists public.mentorship_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  full_name text not null,
  contact text not null,
  current_study_level text not null,
  topic text not null,
  help_description text not null,
  status text not null default 'new' check (status in ('new','contacted','in_progress','closed')),
  created_at timestamptz not null default now()
);

alter table public.mentorship_requests enable row level security;
drop policy if exists "Students can submit their own mentorship requests" on public.mentorship_requests;
create policy "Students can submit their own mentorship requests" on public.mentorship_requests for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Students can read their own mentorship requests" on public.mentorship_requests;
create policy "Students can read their own mentorship requests" on public.mentorship_requests for select to authenticated using (auth.uid() = user_id);

-- Tip: insert institutional directory records in Supabase Table Editor > institutions.
-- Use institution_type: central_university, iit, or nit.
-- Store streams/levels/subjects as PostgreSQL text arrays; leave score fields NULL until there is enough verified feedback.
