# load_data.R
# Shared, typed import for the in-vehicle coupon dataset.
# Used by 01_eda.qmd and 02_data-cleaning.qmd so both start from identical data.
#
# NOTE: every col_*() call is prefixed with readr:: on purpose.
# scales::col_factor() (loaded via library(scales)) otherwise masks readr's version.

load_coupon_data <- function(path = "../data/raw/in-vehicle-coupon-recommendation-1.csv") {

  habit_levels <- c("never", "less1", "1~3", "4~8", "gt8")

  col_types <- readr::cols(
    # unordered categories (levels inferred from the data)
    destination   = readr::col_factor(),
    passanger     = readr::col_factor(),   # (sic) raw header spelling
    weather       = readr::col_factor(),
    coupon        = readr::col_factor(),
    gender        = readr::col_factor(),
    maritalStatus = readr::col_factor(),
    occupation    = readr::col_factor(),

    # ordered categories (explicit levels)
    time       = readr::col_factor(c("7AM", "10AM", "2PM", "6PM", "10PM"), ordered = TRUE),
    expiration = readr::col_factor(c("2h", "1d"), ordered = TRUE),
    age        = readr::col_factor(c("below21", "21", "26", "31", "36", "41", "46", "50plus"),
                                   ordered = TRUE),
    education  = readr::col_factor(c("Some High School", "High School Graduate",
                                     "Some college - no degree", "Associates degree",
                                     "Bachelors degree",
                                     "Graduate degree (Masters or Doctorate)"),
                                   ordered = TRUE),
    income     = readr::col_factor(c("Less than $12500", "$12500 - $24999", "$25000 - $37499",
                                     "$37500 - $49999", "$50000 - $62499", "$62500 - $74999",
                                     "$75000 - $87499", "$87500 - $99999", "$100000 or More"),
                                   ordered = TRUE),
    Bar                  = readr::col_factor(habit_levels, ordered = TRUE),
    CoffeeHouse          = readr::col_factor(habit_levels, ordered = TRUE),
    CarryAway            = readr::col_factor(habit_levels, ordered = TRUE),
    RestaurantLessThan20 = readr::col_factor(habit_levels, ordered = TRUE),
    Restaurant20To50     = readr::col_factor(habit_levels, ordered = TRUE),

    # free text, ~99% missing (dropped in 02)
    car = readr::col_character(),

    # numeric / 0-1 columns stay as integers
    .default = readr::col_integer()   # temperature, Y, has_children, toCoupon_*, direction_*
  )

  readr::read_csv(path, col_types = col_types)
}
