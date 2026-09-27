package com.wcc.platform.repository;

import com.wcc.platform.domain.auth.UserToken;
import java.time.OffsetDateTime;
import java.util.Optional;

public interface UserTokenRepository {
  UserToken create(UserToken token);

  Optional<UserToken> findValidByToken(String token, OffsetDateTime now);

  void revoke(String token);

  void purgeExpired(OffsetDateTime now);

  /**
   * Revokes all active session tokens for the given user.
   *
   * @param userId the user account ID whose tokens should be revoked
   */
  void revokeAllForUser(Integer userId);

  /**
   * Revokes the oldest active (non-revoked, non-expired) tokens for the given user, keeping at
   * most {@code tokensToKeep} of the most recently issued ones active. Used to enforce a cap on
   * the number of concurrently valid tokens per user.
   *
   * @param userId the user account ID whose tokens should be pruned
   * @param now the current time, used to determine which tokens are still active
   * @param tokensToKeep the number of most recently issued active tokens to leave untouched
   */
  void revokeOldestActiveTokens(Integer userId, OffsetDateTime now, int tokensToKeep);
}
