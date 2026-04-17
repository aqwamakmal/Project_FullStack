-- ============================================
-- SkyBooking Database Schema (MySQL)
-- ============================================

-- Create tables for SkyBooking Flight Ticket System
-- Database: sky_booking

-- ============================================
-- 1. USERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  date_of_birth DATE,
  gender ENUM('M', 'F', 'Other'),
  address VARCHAR(255),
  city VARCHAR(50),
  state VARCHAR(50),
  postal_code VARCHAR(10),
  country VARCHAR(50),
  passport_number VARCHAR(20),
  nationality VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  last_login TIMESTAMP NULL,
  is_active BOOLEAN DEFAULT TRUE,
  INDEX idx_email (email),
  INDEX idx_created_at (created_at)
);

-- ============================================
-- 2. AIRLINES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS airlines (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(5) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  logo_url VARCHAR(255),
  country VARCHAR(50),
  phone VARCHAR(20),
  email VARCHAR(100),
  website VARCHAR(100),
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_code (code),
  INDEX idx_name (name)
);

-- ============================================
-- 3. AIRPORTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS airports (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(5) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL,
  city VARCHAR(50) NOT NULL,
  country VARCHAR(50) NOT NULL,
  timezone VARCHAR(10),
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_code (code),
  INDEX idx_city (city),
  INDEX idx_country (country)
);

-- ============================================
-- 4. FLIGHTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS flights (
  id INT AUTO_INCREMENT PRIMARY KEY,
  flight_number VARCHAR(10) NOT NULL,
  airline_id INT NOT NULL,
  departure_airport_id INT NOT NULL,
  arrival_airport_id INT NOT NULL,
  departure_time DATETIME NOT NULL,
  arrival_time DATETIME NOT NULL,
  duration INT,
  aircraft_type VARCHAR(50),
  total_seats INT DEFAULT 180,
  available_seats INT DEFAULT 180,
  price DECIMAL(10, 2) NOT NULL,
  status ENUM('scheduled', 'boarding', 'departed', 'in_flight', 'landed', 'cancelled', 'delayed') DEFAULT 'scheduled',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (airline_id) REFERENCES airlines(id),
  FOREIGN KEY (departure_airport_id) REFERENCES airports(id),
  FOREIGN KEY (arrival_airport_id) REFERENCES airports(id),
  INDEX idx_flight_number (flight_number),
  INDEX idx_departure_time (departure_time),
  INDEX idx_status (status),
  UNIQUE KEY unique_flight (flight_number, departure_time)
);

-- ============================================
-- 5. BOOKINGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS bookings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  booking_code VARCHAR(10) UNIQUE NOT NULL,
  user_id INT NOT NULL,
  flight_id INT NOT NULL,
  booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total_price DECIMAL(10, 2) NOT NULL,
  status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
  payment_status ENUM('pending', 'paid', 'refunded') DEFAULT 'pending',
  payment_method VARCHAR(50),
  payment_date TIMESTAMP NULL,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (flight_id) REFERENCES flights(id),
  INDEX idx_booking_code (booking_code),
  INDEX idx_user_id (user_id),
  INDEX idx_booking_date (booking_date),
  INDEX idx_status (status)
);

-- ============================================
-- 6. PASSENGERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS passengers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(10),
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  date_of_birth DATE NOT NULL,
  gender ENUM('M', 'F', 'Other'),
  passport_number VARCHAR(20),
  passport_country VARCHAR(50),
  passport_expiry DATE,
  nationality VARCHAR(50),
  email VARCHAR(100),
  phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_passport (passport_number),
  INDEX idx_first_name (first_name),
  INDEX idx_last_name (last_name)
);

-- ============================================
-- 7. BOOKING_PASSENGERS TABLE (Junction)
-- ============================================
CREATE TABLE IF NOT EXISTS booking_passengers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  booking_id INT NOT NULL,
  passenger_id INT NOT NULL,
  seat_number VARCHAR(5),
  meal_preference VARCHAR(50),
  special_requests TEXT,
  check_in_status ENUM('not_checked_in', 'checked_in', 'boarded') DEFAULT 'not_checked_in',
  check_in_time TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
  FOREIGN KEY (passenger_id) REFERENCES passengers(id) ON DELETE CASCADE,
  INDEX idx_booking_id (booking_id),
  INDEX idx_passenger_id (passenger_id),
  UNIQUE KEY unique_booking_passenger (booking_id, passenger_id)
);

-- ============================================
-- 8. REVIEWS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS reviews (
  id INT AUTO_INCREMENT PRIMARY KEY,
  flight_id INT NOT NULL,
  user_id INT NOT NULL,
  booking_id INT,
  rating INT NOT NULL,
  title VARCHAR(100),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (flight_id) REFERENCES flights(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  INDEX idx_flight_id (flight_id),
  INDEX idx_user_id (user_id),
  INDEX idx_rating (rating),
  CHECK (rating >= 1 AND rating <= 5)
);

-- ============================================
-- CREATE INDEXES FOR PERFORMANCE
-- ============================================
ALTER TABLE flights ADD INDEX idx_airline_id (airline_id);
ALTER TABLE bookings ADD INDEX idx_flight_id (flight_id);
ALTER TABLE booking_passengers ADD INDEX idx_created_at (created_at);

-- ============================================
-- DONE
-- ============================================
