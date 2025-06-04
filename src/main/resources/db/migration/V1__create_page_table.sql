CREATE TABLE IF NOT EXISTS page
(
    id   TEXT PRIMARY KEY,
    data JSONB NOT NULL
);

-- Lookup tables replacing ENUMs
CREATE TABLE member_types
(
    id   SERIAL PRIMARY KEY,
    type VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE profile_statuses
(
    id     SERIAL PRIMARY KEY,
    status VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE experience_ranges
(
    id    SERIAL PRIMARY KEY,
    label VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE image_types
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE network_types
(
    id      SERIAL PRIMARY KEY,
    network VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE mentorship_types
(
    id   SERIAL PRIMARY KEY,
    type VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE experience_areas
(
    id   SERIAL PRIMARY KEY,
    area VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE resource_types
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE months
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Country normalization
CREATE TABLE countries
(
    id           SERIAL PRIMARY KEY,
    country_code VARCHAR(2) UNIQUE NOT NULL,
    country_name VARCHAR(100)      NOT NULL
);

-- Members (mentors) table
CREATE TABLE members
(
    id                    SERIAL PRIMARY KEY,
    full_name             VARCHAR(255) NOT NULL,
    position              VARCHAR(255) NOT NULL,
    company_name          VARCHAR(255),
    city                  VARCHAR(100),
    country_id            INTEGER REFERENCES countries (id),
    profile_status_id     INTEGER REFERENCES profile_statuses (id),
    bio                   TEXT,
    years_experience      INTEGER,
    experience_range_id   INTEGER REFERENCES experience_ranges (id),
    ideal_mentee          TEXT,
    mentorship_additional TEXT,
    availability_hours    INTEGER,
    created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Member to Type mapping (MENTOR-specific here)
CREATE TABLE member_member_types
(
    id             SERIAL PRIMARY KEY,
    member_id      INTEGER REFERENCES members (id) ON DELETE CASCADE,
    member_type_id INTEGER REFERENCES member_types (id) ON DELETE CASCADE,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (member_id, member_type_id)
);

-- Images
CREATE TABLE member_images
(
    id            SERIAL PRIMARY KEY,
    member_id     INTEGER REFERENCES members (id) ON DELETE CASCADE,
    path          VARCHAR(500) NOT NULL,
    alt_text      VARCHAR(255),
    image_type_id INTEGER REFERENCES image_types (id),
    is_primary    BOOLEAN   DEFAULT FALSE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Social networks
CREATE TABLE member_networks
(
    id              SERIAL PRIMARY KEY,
    member_id       INTEGER REFERENCES members (id) ON DELETE CASCADE,
    network_type_id INTEGER REFERENCES network_types (id),
    link            VARCHAR(500) NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Spoken languages
CREATE TABLE member_spoken_languages
(
    id         SERIAL PRIMARY KEY,
    member_id  INTEGER REFERENCES members (id) ON DELETE CASCADE,
    language   VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (member_id, language)
);

-- Programming skills
CREATE TABLE member_programming_languages
(
    id                SERIAL PRIMARY KEY,
    member_id         INTEGER REFERENCES members (id) ON DELETE CASCADE,
    language          VARCHAR(50) NOT NULL,
    proficiency_level INTEGER CHECK (proficiency_level >= 1 AND proficiency_level <= 5),
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (member_id, language)
);

-- Tech experience areas
CREATE TABLE member_experience_areas
(
    id                 SERIAL PRIMARY KEY,
    member_id          INTEGER REFERENCES members (id) ON DELETE CASCADE,
    experience_area_id INTEGER REFERENCES experience_areas (id),
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (member_id, experience_area_id)
);

-- Mentorship types
CREATE TABLE member_mentorship_types
(
    id                 SERIAL PRIMARY KEY,
    member_id          INTEGER REFERENCES members (id) ON DELETE CASCADE,
    mentorship_type_id INTEGER REFERENCES mentorship_types (id),
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (member_id, mentorship_type_id)
);

-- Availability months
CREATE TABLE member_availability_months
(
    id         SERIAL PRIMARY KEY,
    member_id  INTEGER REFERENCES members (id) ON DELETE CASCADE,
    month_id   INTEGER REFERENCES months (id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (member_id, month_id)
);

-- Mentorship focus
CREATE TABLE member_mentorship_focus
(
    id         SERIAL PRIMARY KEY,
    member_id  INTEGER REFERENCES members (id) ON DELETE CASCADE,
    focus_area VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Feedback
CREATE TABLE member_feedbacks
(
    id                 SERIAL PRIMARY KEY,
    member_id          INTEGER REFERENCES members (id) ON DELETE CASCADE,
    rating             INTEGER CHECK (rating >= 1 AND rating <= 5),
    feedback_date      DATE NOT NULL,
    feedback_text      TEXT,
    reviewer_name      VARCHAR(255),
    mentorship_type_id INTEGER REFERENCES mentorship_types (id),
    is_anonymous       BOOLEAN   DEFAULT FALSE,
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Shared resources
CREATE TABLE member_resources
(
    id               SERIAL PRIMARY KEY,
    member_id        INTEGER REFERENCES members (id) ON DELETE CASCADE,
    external_id      VARCHAR(50),
    name             VARCHAR(255) NOT NULL,
    description      TEXT,
    raw_content      TEXT,
    resource_type_id INTEGER REFERENCES resource_types (id),
    link_label       VARCHAR(255),
    link_uri         VARCHAR(500),
    file_path        VARCHAR(500),
    is_active        BOOLEAN   DEFAULT TRUE,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);